#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Characterize Pockels cell V_pi by sweeping DAC904 voltage and measuring optical power with Thorlabs PM100D."""

import sys
sys.path.append('.')
sys.path.append('/home/petalinux/fpga_lab_sprint/python')
from drivers import ZynqBoard

import argparse
from ThorlabsPM100 import ThorlabsPM100, USBTMC
import pyvisa
import time
import csv
import numpy
import scipy.optimize
import matplotlib.pyplot as plt

parser = argparse.ArgumentParser(
    description='Characterize Pockels cell V_pi by sweeping DAC904 voltage and reading PM100D power.',
    formatter_class=argparse.ArgumentDefaultsHelpFormatter
)
parser.add_argument('-o', '--name', type=str, default='', help='String to identify this measurement')
parser.add_argument('-p', '--powermeter-device', type=str, default='', help='Path to PM100D USBTMC device (Linux only)')
parser.add_argument('-n', '--serial-number', type=str, default='', help='Serial number of powermeter (Windows, e.g. P0049446)')
parser.add_argument('--v-min', type=float, default=-1400, help='Minimum DAC voltage in mV')
parser.add_argument('--v-max', type=float, default=1400, help='Maximum DAC voltage in mV')
parser.add_argument('--v-step', type=float, default=50, help='Voltage step in mV')
parser.add_argument('--settling-time', type=float, default=0, help='Settling time after each voltage set in seconds')
parser.add_argument('--averages', type=int, default=100, help='PM100D averaging count per reading')
args = parser.parse_args()

if sys.platform != 'linux':
    WINDOWS = True
    if args.serial_number == '':
        print('Please provide a powermeter serial number (-n)')
        sys.exit()
    sn = args.serial_number
else:
    WINDOWS = False
    if args.powermeter_device == '':
        print('Please provide a powermeter device path (-p)')
        sys.exit()
    pmdevice = args.powermeter_device

if args.name == '':
    mname = input('Please enter a measurement name: ').strip() or 'pockels'
    mname = mname.replace(' ', '_')
else:
    mname = args.name.replace(' ', '_')

# --- DAC ---
board = ZynqBoard.create_board()
dac = board.get_dac904()

# --- Powermeter ---
if WINDOWS:
    rm = pyvisa.ResourceManager()
    inst = rm.open_resource(f'USB0::0x1313::0x8078::{sn}::INSTR')
    inst.read_termination = '\n'
    inst.write_termination = '\n'
    inst.timeout = 1000
else:
    inst = USBTMC(device=pmdevice)
pm = ThorlabsPM100(inst=inst)
pm.sense.average.count = args.averages

voltages_requested = numpy.arange(args.v_min, args.v_max + args.v_step / 2, args.v_step)
voltages_actual = []
power = []

fname = mname + '.csv'
with open(fname, mode='w', newline='\n') as f:
    fwriter = csv.writer(f, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    fwriter.writerow(['voltage_mV', mname + '_mW'])
    for v in voltages_requested:
        actual_v, dac_val = dac.set_voltage(int(round(v)))
        time.sleep(args.settling_time)
        pw = pm.read * 1000  # W -> mW
        voltages_actual.append(actual_v)
        power.append(pw)
        fwriter.writerow([actual_v, pw])
        print(f'V = {actual_v:+8.1f} mV,  P = {pw:.5f} mW  (DAC word: {dac_val})')

# Reset DAC to 0 V after sweep
dac.set_voltage(0)
print('DAC reset to 0 mV')

if WINDOWS:
    rm.close()

voltages_actual = numpy.array(voltages_actual, dtype=float)
power = numpy.array(power, dtype=float)

# --- Fit ---
# Pockels cell between crossed/parallel polarizers:
#   P(V) = A + B * sin^2( pi*V / (2*Vpi) + phi )
# phi covers both crossed (phi=0) and parallel (phi=pi/2) configurations.
def pockels_func(V, A, B, Vpi, phi):
    return A + B * numpy.sin(numpy.pi * V / (2.0 * Vpi) + phi) ** 2

A0 = power.min()
B0 = power.max() - power.min()
Vpi0 = (args.v_max - args.v_min) / 4.0
phi0 = 0.0

Vpi = None
popt = None
try:
    popt, _ = scipy.optimize.curve_fit(
        pockels_func, voltages_actual, power,
        p0=[A0, B0, Vpi0, phi0],
        maxfev=20000
    )
    A, B, Vpi, phi = popt
    print(f'\nFit:  A = {A:.5f} mW,  B = {B:.5f} mW,  V_pi = {abs(Vpi):.1f} mV,  phi = {phi:.3f} rad')
except RuntimeError as e:
    print(f'Fit failed: {e}')

# --- Plot ---
fig, ax = plt.subplots()
ax.plot(voltages_actual, power, linestyle='none', marker='o', ms=3, label='Data')

if popt is not None:
    vplot = numpy.linspace(voltages_actual.min(), voltages_actual.max(), 2000)
    ax.plot(vplot, pockels_func(vplot, *popt), label=f'Fit: $V_\\pi$ = {abs(Vpi):.1f} mV')

ax.set_xlabel('Voltage (mV)', fontsize=12, fontweight='bold')
ax.set_ylabel('Power (mW)', fontsize=12, fontweight='bold')
plt.title(f'Pockels cell: {mname}', fontsize=14, fontweight='bold')
ax.legend()
plt.tick_params(axis='x', labelsize=12)
plt.tick_params(axis='y', labelsize=12)
fig.tight_layout()
plt.savefig(mname + '.pdf', format='pdf', transparent=True, bbox_inches='tight', pad_inches=0)
plt.savefig(mname + '.png', format='png', transparent=True, bbox_inches='tight', pad_inches=0)
print(f'Saved {mname}.pdf and {mname}.png')
plt.show()
