import sys
sys.path.append('.')
sys.path.append('/home/petalinux/fpga_lab_sprint/python')
from drivers import *
import json
import argparse
import traceback

class DAC904:
    def __init__(self):
        """ Initialize the DAC904 class """
        self.board = ZynqBoard.create_board()
        self.dac904 = self.board.get_dac904()
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Test DAC904.",
                                         formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('--voltage', type=int, default=0, help='DAC Voltage in mV (-3000 to 3000)')
    parser.add_argument('--mode', type=str, default='single', choices=['single', 'ramp_on','ramp_off', 'pulse_binary'], help='Operation mode')
    parser.add_argument('--pulse_high_width_ns', type=int, default=100, help='Pulse high width in ns (only for pulse_binary mode)')
    parser.add_argument('--pulse_low_width_ns', type=int, default=100, help='Pulse low width in ns (only for pulse_binary mode)')
    args = parser.parse_args()
    print(args)
    time.sleep(1)

    measurement = None
    try:
        measurement = DAC904()
        match args.mode:
            case 'single':
                measurement.dac904.set_voltage(args.voltage)
                print(f'Set DAC value to {args.voltage} mV')
            case 'ramp_on':
                measurement.dac904.ramp()
                print('Ramping DAC voltage from -3000 mV to 3000 mV')
            case 'ramp_off':
                measurement.dac904.reset()
                print('Resetting DAC voltage to 0 mV')
            case 'pulse_binary':
                measurement.dac904.pulse_binary(args.voltage, args.pulse_high_width_ns, args.pulse_low_width_ns)
                print(f'Pulsing DAC with {args.voltage} mV, high width: {args.pulse_high_width_ns} ns, low width: {args.pulse_low_width_ns} ns')
    except Exception as e:
        print(f'Error: {e}')
        traceback.print_exc()

