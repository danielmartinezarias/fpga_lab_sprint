# read version
import sys
sys.path.append('.')
from drivers import *

if __name__ == "__main__":
    z = ZynqBoard.create_board()
    print('fpga_lab_sprint version:', z.version())