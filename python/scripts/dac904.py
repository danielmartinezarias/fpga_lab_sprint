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
    args = parser.parse_args()
    print(args)
    time.sleep(1)

    measurement = None
    try:
        measurement = DAC904()
        match args.mode:
            case 'single':
                measurement.dac904.set_dac904_voltage(args.voltage)
                print(f'Set DAC value to {args.voltage} mV')
            case 'ramp_on':
                measurement.dac904.ramp_dac904()
                print('Ramping DAC voltage from -3000 mV to 3000 mV')
            case 'ramp_off':
                measurement.dac904.reset_dac904()
                print('Resetting DAC voltage to 0 mV')
    except Exception as e:
        print(f'Error: {e}')
        traceback.print_exc()

