import mmap
import os
import sys
import time
import json
#import numpy as np
import threading

global MAP_MASK
MAP_MASK = mmap.PAGESIZE - 1  # TODO: what is this?
default_sleep = 0.1
if os.geteuid() != 0:
    sys.exit("Please run as root, preseving env (sudo -E python3 script.py).")

class ZynqBoard:

    def __init__(self, board):
        config_path = os.path.join(os.path.dirname(__file__), "config/config_driver.json")
        try:
            with open(config_path, "r", encoding="utf-8") as file:
                self.config = json.load(file)
                #self.config = remove_comments_from_json(json.load(file))
        except FileNotFoundError:
            raise FileNotFoundError(f"Configuration file not found at {config_path}."
                                    f" Please ensure the 'config' folder exists and is correctly named.")

        self.ADDRESSES = lambda addr: int(self.config["zynq_boards"]["addresses"][addr], 16)
        self.VALUES = lambda value: int(self.config["zynq_boards"]["values"][value], 16)
        self.read_mutex = threading.Lock()
        self.write_mutex = threading.Lock()

        # load calibration data for different models
        if board == "Zedboard":
#            self.config_calib_path = os.path.join(os.path.dirname(__file__), "config/calibration_FM.json")
#            try:
#                with open(self.config_calib_path, "r", encoding="utf-8") as file:
#                    self.calibration = remove_comments_from_json(json.load(file))
#            except FileNotFoundError:
#                raise FileNotFoundError(f"Calibration file not found at {config_calib_path}."
#                                        f" Please ensure the 'config' folder exists and is correctly named.")

            self.address_offset = int(self.config["zynq_boards"]["Zedboard"]["address_offset"], 16)

    @staticmethod
    def create_board():
        """
        Creates board from environment variable "FPGA_MODEL"
        """
        if os.environ.get('FPGA_MODEL') == 'ZedBoard':
            return ZynqBoard.create_zedboard()
        else: 
            model = os.getenv("FPGA_MODEL")
            if not model:
                sys.exit("FPGA_MODEL not set — export FP_MODEL='ZedBoard' before running.")

    @staticmethod
    def create_zedboard():
        return ZynqBoard(board="Zedboard")

    def version(self):
        return self.read_addr(self.ADDRESSES("VERSION"))

    def test_reg_read(self):                
        return self.read_addr(self.ADDRESSES("TEST_REG"))

    def test_reg_write(self, a):
        self.write_addr(self.ADDRESSES("TEST_REG"), a)

    def read_addr(self, addr: int, length=4):
        addr_new = self.address_offset + addr*4

        with self.read_mutex:
            f = os.open("/dev/mem", os.O_RDWR | os.O_SYNC)
            mem = mmap.mmap(f, mmap.PAGESIZE, mmap.MAP_SHARED, mmap.PROT_READ | mmap.PROT_WRITE, offset=addr_new & ~MAP_MASK)
            mem.seek(addr_new & MAP_MASK)
            val = mem.read(length)
            mem.close()
            os.close(f)
        return int.from_bytes(val, byteorder='little')

    def write_addr_bytes(self, addr: int, value: bytes) -> int:
        addr_new = self.address_offset + addr*4
        with self.write_mutex:
            f = os.open("/dev/mem", os.O_RDWR | os.O_SYNC)
            mem = mmap.mmap(f, mmap.PAGESIZE, mmap.MAP_SHARED, mmap.PROT_READ | mmap.PROT_WRITE,
                            offset=addr_new & ~MAP_MASK)
            mem.seek(self.address_offset + addr_new & MAP_MASK)
            x = mem.write(value)
            mem.close()
            os.close(f)
        return x

    def write_addr(self, addr: int, value: int, length: int=4) -> int:
        return self.write_addr_bytes(addr, value.to_bytes(length, byteorder='little'))


