import sys
sys.path.append('.')
import os
import pprint
import time
from drivers import *
import json
import argparse
import traceback
import glob


class TimeTagger:
    def __init__(self):
        """ Initialize the TimeTagger class """
        self.board = ZynqBoard.create_board()
        self.timetagger = None


    def readTimeTagger(self, c_win, int_time):
        """ Read the time tagger and calculate accidental counts """
        tt = self.timetagger.read_time_tagger()
        time_tag = {}
        int_time = int_time / 1000  # ms to s
        c_win = c_win*27*10**(-12)  # NTaps(27ps each) to s
        for channel, counts in tt.items():
            if channel.startswith("CC"):
                sA = tt[f'C{channel[2]}']
                sB = tt[f'C{channel[3]}']
                acc = round((sA/int_time)*(sB/int_time)*c_win*int_time)
            else:
                acc = 0
            tt_acc ={'Counts': counts, 'Acc': acc}
            time_tag[channel] = tt_acc
        return time_tag
        
    
    def setExperiment(self, s_win, c_win, int_time, delays):
        """ Set up the experiment parameters """

        self.timetagger = self.board.get_timetagger(
            s_win,
            c_win,
            int_time,
            *delays)

        start = time.time()


    def resetExperiment(self):
        """ Reset the experiment """
        self.timetagger.reset_registers()

        

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Test Timetagger.",
                                         formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    # parser.add_argument("--sleep", type=int, default=1, help="Waiting time between tests in seconds")
    parser.add_argument("--s_win", type=int, default=100, help="Sampling window in ms")
    parser.add_argument("--c_win", type=int, default=170, help="Coincidence window in ms")
    parser.add_argument("--int_t", type=int, default=1000, help="Integration time in ms")
    parser.add_argument("--delays", type=list_of_ints, default=[-1, -1, -1, -1, -1, -1], help="delays")
    parser.add_argument("--log_level", type=str, default="INFO", help="loglevel")

    args = defaults_parse_args(parser, sys.argv)

    print(args)
    time.sleep(1)

    measurement = None
    try:
        measurement = TimeTagger()
        measurement.setExperiment(args.s_win, args.c_win, args.int_t, args.delays)
        filename = (f"{time.time_ns()}_timetagger_data")
        zynq_setup_logging(filename)
        count = 0
        while True:
            time_tags = measurement.readTimeTagger(args.c_win, args.int_t)

            all_data = { count :{
                    "time_tags": time_tags
                }
            }
            zynq_save_results(all_data, filename)
            count+=1
            try: 
                os.system('clear')
                pprint.pp(time_tags)
            except Exception:
                pass
            print('press CTRL-C to stop reading')
            #time.sleep(1)
    except KeyboardInterrupt:
        pass
    except Exception as e:
        zynq_log(f"Error in TimeTagger: {traceback.format_exc()}", level="error")
    finally:
        if measurement:
            measurement.resetExperiment()
    
