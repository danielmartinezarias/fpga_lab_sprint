import sys
sys.path.append('/home/petalinux/fpga_lab_sprint/python')
from drivers import *
import json
import argparse

class DAC904:
    def __init__(self):
        """ Initialize the DAC904 class """
        self.board = ZynqBoard.create_board()
        self.dac904 = self.board.get_dac904()
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Test DAC904.",
                                         formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('--voltage', type=int, default=0, help='DAC Voltage in mV (-3000 to 3000)')
    args = parser.parse_args()
    print(args)
    time.sleep(1)

    dac904 = None
    try:
        dac904 = DAC904()
        dac904.set_dac904_voltage(args.voltasge)
        print(f'Set DAC value to {args.voltage} mV')
    except Exception as e:
        print(f'Error: {e}')

