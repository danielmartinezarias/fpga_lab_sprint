import sys
sys.path.append('.')
sys.path.append('/home/petalinux/fpga_lab_sprint/python')
from drivers import *
import traceback


class DAC904:
    def __init__(self):
        """ Initialize the DAC904 class """
        self.board = ZynqBoard.create_board()
        self.dac904 = self.board.get_dac904()


def set_raw_code(dac, code):
    """ Drive a raw 14-bit code onto the DAC in continuous mode.

    This deliberately bypasses set_voltage()'s mV->code formula so the
    measurement reflects the *hardware* transfer function only, not the
    calibration we are trying to verify.
    """
    dac.zynqboard.write_addr(dac.ADDRESSES("CONTROL_DAC904"),
                             dac.VALUES("CONTROL_DAC904_CONTINUOUS"))
    dac.zynqboard.write_addr(dac.ADDRESSES("DATA_DAC904"), int(code))


def ask_mv(prompt):
    while True:
        try:
            return float(input(prompt).strip())
        except ValueError:
            print("  Please enter a number (mV), e.g. -1680.0")


if __name__ == "__main__":
    try:
        measurement = DAC904()
        dac = measurement.dac904

        res = int(dac.DACCalib["resolution"])      # 14
        FS = 2 ** res                              # 16384  (formula's full scale)
        MID = 2 ** (res - 1)                       # 8192   (formula's 0 V / midscale)
        MAXCODE = FS - 1                           # 16383  (largest 14-bit code)

        print("=== DAC904 calibration ===")
        print("For each step the DAC is driven to a fixed code. Read the")
        print("steady output on the PicoScope and type the value in mV.\n")

        # --- Step 1: code 0 (one rail) ---
        set_raw_code(dac, 0)
        time.sleep(0.5)
        v_zero = ask_mv(f"Code 0 driven. PicoScope reading [mV]: ")

        # --- Step 2: code 16383 (other rail) ---
        set_raw_code(dac, MAXCODE)
        time.sleep(0.5)
        v_full = ask_mv(f"Code {MAXCODE} driven. PicoScope reading [mV]: ")

        # --- Step 3: midscale (what set_voltage(0) actually outputs) ---
        set_raw_code(dac, MID)
        time.sleep(0.5)
        v_mid = ask_mv(f"Code {MID} (midscale) driven. PicoScope reading [mV]: ")

        # leave the DAC at midscale (~0 V) when done
        set_raw_code(dac, MID)

        # --- Compute corrected calibration ---
        # Hardware is linear: V(code) = m*code + b
        m = (v_full - v_zero) / (MAXCODE - 0)      # mV per code (negative: inverted convention)

        # set_voltage uses:  code = voltage/(min-max)*FS + MID
        # Round-trip V(code(v)) == v requires:
        #   (min - max) = m * FS      ->   span = (max - min) = -m * FS
        #   midscale must read 0 V    ->   any residual is an offset the formula can't absorb
        max_voltage = -m * MID                     # = span/2
        min_voltage =  m * MID                     # = -span/2

        assumed_m = (dac.DACCalib["min_voltage"] - dac.DACCalib["max_voltage"]) / FS

        print("\n=== Results ===")
        print(f"Measured slope : {m:.5f} mV/code")
        print(f"Assumed slope  : {assumed_m:.5f} mV/code  "
              f"(from current min/max = {dac.DACCalib['min_voltage']}..{dac.DACCalib['max_voltage']})")
        print(f"Scale error    : {assumed_m / m:.3f}x  "
              f"(set_voltage output is off by roughly this factor)\n")

        print("Corrected values for config/calibration.json -> \"dac904\":")
        print(f'    "min_voltage": {round(min_voltage)},')
        print(f'    "max_voltage": {round(max_voltage)},\n')

        print(f"Midscale (code {MID}) measured: {v_mid:.2f} mV")
        if abs(v_mid) < 1.0:
            print("  -> Offset negligible. Fixing min/max above is sufficient.")
        else:
            print(f"  -> OFFSET of {v_mid:.2f} mV detected. The current driver/config")
            print("     CANNOT represent this (it hardcodes 0 V at midscale). See note below.")

    except Exception as e:
        print(f'Error: {e}')
        traceback.print_exc()
