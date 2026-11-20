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
    parser.add_argument('--mode', type=str, default='home', choices=['hom'], help='Operation mode')
    parser.add_argument('--V0', type=int, default=0x1FFF, help='Initial voltage')
    parser.add_argument('--V_STEP', type=int, default=0xF, help='Voltage step')
    parser.add_argument('--DAC_V_SPIKE', type=int, default=0x2FFF, help='DAC voltage spike')
    parser.add_argument('--REFRACT_TIME', type=int, default=0x7A120, help='Refractory time')
    parser.add_argument('--INT_TIME', type=int, default=1, help='Integration time')
    parser.add_argument('--COIN_WINDOW', type=int, default=10, help='Coincidence window')

    args = parser.parse_args()
    print(args)
    time.sleep(1)


    measurement = None
    try:
        measurement = QLIFPhotonUpdate()
        tt = measurement.board.get_time_tagger(int_time_ms=args.INT_TIME, coin_window_ns=args.COIN_WINDOW)
        # registers = measurement.qlif_photon_update.read_all_registers()
        # print("Current register values:")
        # print(json.dumps(registers, indent=4))
        measurement.qlif_photon_update.hom_based_update(V0=args.V0, V_STEP=args.V_STEP, DAC_V_SPIKE=args.DAC_V_SPIKE, REFRACT_TIME=args.REFRACT_TIME)
        print("HOM-based update completed successfully.")


    
    except Exception as e:
        print(f"Error: {e}")
        traceback.print_exc()