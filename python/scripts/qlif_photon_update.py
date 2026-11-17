import sys
sys.path.append('.')
sys.path.append('/home/petalinux/fpga_lab_sprint/python')
from drivers import *
import json
import argparse
import traceback

class QLIFPhotonUpdate:
    def __init__(self):
        """ Initialize the QLIFPhotonUpdate class """
        self.board = ZynqBoard.create_board()
        self.qlif_photon_update = self.board.get_qlif_photon_update()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="QLIFPhotonUpdate.",
                                         formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('--mode', type=str, default='single', choices=['single', 'ramp_on','ramp_off', 'pulse_binary','pulse_memory','waveform_from_json','waveform_sinusoidal','off'], help='Operation mode')
    args = parser.parse_args()
    print(args)
    time.sleep(1)

    measurement = None
    try:
        measurement = QLIFPhotonUpdate()
        registers = measurement.qlif_photon_update.read_all_registers()
        print("Current register values:")
        print(json.dumps(registers, indent=4))
    
    except Exception as e:
        print(f"Error: {e}")
        traceback.print_exc()