import mmap
import os
import sys
import time
import json
#import numpy as np
import threading
global logger
global file_lock
file_lock = threading.Lock()

import logging
logger = logging.getLogger("ZYNQ",)
fmt = logging.Formatter('[%(levelname)s] %(asctime)s: %(message)s')
logging_available = True

global MAP_MASK
MAP_MASK = mmap.PAGESIZE - 1  # TODO: what is this?
default_sleep = 0.1
# Ensure the script is run as root
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
           self.config_calib_path = os.path.join(os.path.dirname(__file__), "config/calibration.json")
           self.address_offset = int(self.config["zynq_boards"]["Zedboard"]["address_offset"], 16)
           try:
               with open(self.config_calib_path, "r", encoding="utf-8") as file:
                   self.calibration = json.load(file)
                #    self.calibration = remove_comments_from_json(json.load(file))
           except FileNotFoundError:
               raise FileNotFoundError(f"Calibration file not found at {config_calib_path}."
                                       f" Please ensure the 'config' folder exists and is correctly named.")

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
                sys.exit("FPGA_MODEL not set — export FPGA_MODEL='ZedBoard' before running.")

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
    
    def get_timetagger(self, sampling_window_ns: int=-1, coin_window_ns: int=-1, int_time_ms: int=-1,
                    delay0 :int=-1, delay1: int=-1, delay2: int=-1, delay3: int=-1, delay4: int=-1, delay5: int=-1):
        """ Returns an instance of the TimeTagger
        :param sampling_window_ns: Sampling Window in Nanoseconds
        :param coin_window_ns: Coincidence Window in Nanoseconds
        :param int_time_ms: Integration Time in Milliseconds
        :param delay0: Delay0: default: 0
        :param delay1: Delay1: default: 0
        :param delay2: Delay2: default: 0
        :param delay3: Delay3: default: 0
        :param delay4: Delay4: default: 0
        :param delay5: Delay5: default: 0
        :return:
        """
        return self._TimeTagger(self, sampling_window_ns, coin_window_ns, int_time_ms,
                                delay0, delay1, delay2, delay3, delay4, delay5)

    ################################################################################################################
    ############################################### TimeTagger class ###############################################
    ################################################################################################################

    class _TimeTagger:
        def __init__(self, zynqboard,
                     sampling_window_ns: int=-1, coin_window_ns: int=-1, int_time_ms: int=-1,
                     delay0 :int=-1, delay1: int=-1, delay2: int=-1, delay3: int=-1, delay4: int=-1, delay5: int=-1):
            """ Returns an instance of the TimeTagger
            :param sampling_window_ns: Sampling Window in Nanoseconds default: -1 (taken from calibration)
            :param coin_window_ns: Coincidence Window in Nanoseconds default: -1 (taken from calibration)
            :param int_time_ms: Integration Time in Milliseconds default: -1 (taken from calibration)
            :param delay0: Delay0: default: -1 (taken from calibration)
            :param delay1: Delay1: default: -1 (taken from calibration)
            :param delay2: Delay2: default: -1 (taken from calibration)
            :param delay3: Delay3: default: -1 (taken from calibration)
            :param delay4: Delay4: default: -1 (taken from calibration)
            :param delay5: Delay5: default: -1 (taken from calibration)
            :return:
            """

            self.zynqboard=zynqboard

            self.TTConfig = self.zynqboard.config["timetagger"]
            self.TTCalib = self.zynqboard.calibration["timetagger"]
            self.CHANNEL_MAPPING = self.TTCalib["channel_mapping"]

            self.ADDRESSES = lambda addr: int(self.TTConfig["addresses"][addr], 16)
            self.VALUES = lambda value: int(self.TTConfig["values"][value], 16)

            self.coin_address = {k: int(v, 16) for k, v in self.TTConfig["coin_address"].items()}
            self.length = self.TTConfig["length"]
            self.clock_speed = self.TTConfig["clock_speed"]

            self.sampling_window_ns = self.TTCalib["sampling_window_ns"] if sampling_window_ns < 0 else sampling_window_ns
            self.coin_window_ns = self.TTCalib["coin_window_ns"] if coin_window_ns < 0 else coin_window_ns
            self.full_int_time_ms = self.TTCalib["int_time_ms"] if int_time_ms < 0 else int_time_ms
            self.int_time_ms = self.TTConfig["max_int_time"]

            self.delay0 = self.TTCalib["delay0"] if delay0 < 0 else delay0
            self.delay1 = self.TTCalib["delay1"] if delay1 < 0 else delay1
            self.delay2 = self.TTCalib["delay2"] if delay2 < 0 else delay2
            self.delay3 = self.TTCalib["delay3"] if delay3 < 0 else delay3
            self.delay4 = self.TTCalib["delay4"] if delay4 < 0 else delay4
            self.delay5 = self.TTCalib["delay5"] if delay5 < 0 else delay5

            self.set_parameters()

        def set_parameters(self):
            # Set Parameters for the TimeTagger on FPGA
            self.zynqboard.write_addr(self.ADDRESSES("SAMPLING_WINDOW"), int(self.sampling_window_ns / 10**9 *
                                                                             self.clock_speed))
            # TODO: Characterization by Dani
            self.zynqboard.write_addr(self.ADDRESSES("COIN_WINDOW"), int(self.coin_window_ns))
            self.zynqboard.write_addr(self.ADDRESSES("INT_TIME"), int(self.int_time_ms/1000*self.clock_speed))
            self.zynqboard.write_addr(self.ADDRESSES(f"DELAY{self.CHANNEL_MAPPING['TT_C0']}"), self.delay0)
            self.zynqboard.write_addr(self.ADDRESSES(f"DELAY{self.CHANNEL_MAPPING['TT_C1']}"), self.delay1)
            self.zynqboard.write_addr(self.ADDRESSES(f"DELAY{self.CHANNEL_MAPPING['TT_C2']}"), self.delay2)
            self.zynqboard.write_addr(self.ADDRESSES(f"DELAY{self.CHANNEL_MAPPING['TT_C3']}"), self.delay3)
            self.zynqboard.write_addr(self.ADDRESSES(f"DELAY{self.CHANNEL_MAPPING['TT_C4']}"), self.delay4)
            self.zynqboard.write_addr(self.ADDRESSES(f"DELAY{self.CHANNEL_MAPPING['TT_C5']}"), self.delay5)



        def _read_tags(self):
            """ Read the counts register."""
            tags = {}
            for k, addr in self.coin_address.items():
                if (k.startswith("TT_CC")
                        and self.CHANNEL_MAPPING[f'TT_C{k[5]}'] >= 0
                        and self.CHANNEL_MAPPING[f'TT_C{k[6]}'] >= 0):
                    key = "CC" + "".join(map(str,sorted([self.CHANNEL_MAPPING[f'TT_C{k[5]}'],
                                                         self.CHANNEL_MAPPING[f'TT_C{k[6]}']])))
                elif self.CHANNEL_MAPPING[k] >= 0:
                    key = f"C{self.CHANNEL_MAPPING[k]}"
                else:
                    key = None
                if key is not None:
                    tags[key] = self.zynqboard.read_addr(addr, self.length)
            return dict(sorted(tags.items()))

        def read_time_tagger(self, ret_single_readings=False):
            """
            Read the timetags from the timetagger.
            Writes the Start command to the FPGA, waits for 1.1 seconds and than reads the timetags.
            @param ret_single_readings: if True, returns a dictionary with the sequential integration times (e.g. 10 sec) as key and the tags as value.
                If False, returns a dictionary with the channels as keys and the summed up coincidences as values.        
            :return: dictionary with channels and coincidences and their values.
            """
            int_time = 0
            ret = {}
            while int_time < self.full_int_time_ms:
                self.int_time_ms = min(self.full_int_time_ms - int_time, self.TTConfig["max_int_time"])
                self.set_parameters()
                int_time += self.int_time_ms

                self.reset_fsm()               
                last_tags = self._read_tags()
                self.zynqboard.write_addr(
                    self.ADDRESSES("START_TIME_TAGGER"),self.VALUES("START"), self.length)
                #wait for the integration time to finish
                time.sleep((self.int_time_ms/1000) + 1)
                #time.sleep(int(self.TTCalib["extra_sleep"]))
                
                tags = last_tags.copy()
                start = time.time()
                while tags == last_tags and (time.time() - start) < self.TTCalib["extra_sleep"]:
                    # roquet_log(f"Waiting for new tags since {time.time() - start} sec... ", level="DEBUG")
                    tags = self._read_tags()
                    time.sleep(5*default_sleep)

                if not ret_single_readings:
                    for key in tags.keys():
                        if key in ret:
                            ret[key] += tags[key]
                        else:
                            ret[key] = tags[key]
                else:
                    ret[int_time] = tags
                time.sleep(default_sleep)

            return ret

        def reset_registers(self):
            """
            reset all registers of this class to value zero
            """
            self.sampling_window_clk = 0
            self.coin_window_clk = 0
            self.int_time_clk = 0
            self.delay0 = 0
            self.delay1 = 0
            self.delay2 = 0
            self.delay3 = 0
            self.delay4 = 0
            self.delay5 = 0
            self.set_parameters()
            self.reset_fsm()

        def reset_fsm(self):
            """
            Reset the Finite State Machine of the timetagger
            """
            if self.zynqboard.version() >= 76:
                self.zynqboard.write_addr(self.ADDRESSES("RESET"), self.VALUES("START_RESET"))
                time.sleep(default_sleep)



###########################################################################################
###################### Utils functions for logging and saving results #####################
###########################################################################################

def zynq_save_results(results, filename, folder=""):
    path = f"results/{str(os.environ.get('FPGA_MODEL'))}/{folder}"
    os.makedirs(path, exist_ok=True)
    output_path = os.path.join(path, f"{filename}.json")
    with file_lock:
        try:
            with open(output_path, "r") as json_file:
                file_data = json.loads(json_file.read())
        except FileNotFoundError:
            file_data = {}
            zynq_log(f"File {output_path} not found, creating a new one.")
        # change it
        file_data.update(results)
        # write it all back
        with open(output_path, "w") as json_file:
            json_file.write(json.dumps(file_data))

    return output_path

def zynq_log(msg, level="info"):
    global logger
    level = getattr(logging, level.upper(), None)
    logger.log(level, msg)


def zynq_setup_logging(filename, folder="", level="INFO"):
    global logger
    path = f"results/{str(os.environ.get('FPGA_MODEL'))}/{folder}"
    os.makedirs(path, exist_ok=True)
    output_path = os.path.join(path, f"{filename}.log")

    logger.setLevel(level.upper())
    if not logger.hasHandlers():
        sh = logging.StreamHandler(sys.stdout)
        sh.setFormatter(fmt)
        fh = logging.FileHandler(output_path)
        fh.setFormatter(fmt)
        if not os.environ.get("FPGA_MODEL") or os.environ.get("FPGA_MODEL").upper() in ["TEST", "ZEDBOARD"]:
            logger.addHandler(sh)
            logger.addHandler(fh)
        else:
            logger.addHandler(fh)

def list_of_ints(arg):
    return list(map(int, arg.split(',')))

def list_of_floats(arg):
    return list(map(float, arg.split(',')))

def defaults_parse_args(parser, argv):
    # instead of failing, on a parsing error we load the defaults
    # 
    # When parsing failes, argparse writes an errormessage and exits.
    # there is no meaningful information in the thrown exception
    # 
    # simply asking for the help test via --help / -h ALSO THROWS THE EXACT SAME Exception
    # which means that "--help" would start the script with default values.
    # we can check the args to the script to work around this issue
    onlyhelp = "--help" in argv or "-h" in argv
    try:
        args = parser.parse_args(argv)
    except:
        zynq_log('Failed to parse arguments. Using defaults.', level="error")
        args = parser.parse_args([])
        if onlyhelp:
            sys.exit()
    return args

