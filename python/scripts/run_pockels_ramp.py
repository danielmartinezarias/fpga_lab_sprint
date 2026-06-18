#!/usr/bin/env python3
"""
run_pockels_ramp.py -- drive the DAC sawtooth for Pockels-cell characterization.

Sequence: bring up DPS3005 -> confirm operator readiness -> start DAC ramp ->
hold while the PicoScope records -> ALWAYS stop the ramp and drop the supply.

The supply/ramp shutdown runs in a finally block so HV is switched off even on
error or Ctrl-C. Run from ~/fpga_lab_sprint/python/ as:
    sudo -E python3 scripts/run_pockels_ramp.py
"""

import argparse
import datetime as dt
import re
import subprocess
import sys
import time
from pathlib import Path

PORT = "/dev/ttyUSB0"
SCRIPT_DIR = Path(__file__).resolve().parent
DAC = SCRIPT_DIR / "dac904.py"
DPS = SCRIPT_DIR / "dps3005.py"

HARD_DAC_LIMIT_MV = 3000.0      # hardware path limit; do not exceed
SUPPLY_V = 5.00
SUPPLY_A = 2.0 #200mA


def log(msg: str) -> None:
    print(f"[{dt.datetime.now():%H:%M:%S}] {msg}", flush=True)


def dac(*args, check=True):
    cmd = ["sudo", "-E", "python3", str(DAC), *map(str, args)]
    log("$ " + " ".join(cmd))
    return subprocess.run(cmd, text=True, check=check)


def dps(*args, check=True, capture=False):
    cmd = ["sudo", "-E", "python3", str(DPS), "--port", PORT, *map(str, args)]
    log("$ " + " ".join(cmd))
    return subprocess.run(cmd, text=True, check=check, capture_output=capture)


def supply_is_on() -> bool:
    """Read DPS3005 status once and confirm the output is actually ON."""
    out = dps("status", capture=True).stdout
    m = re.search(r"Output:\s*(ON|OFF)", out, re.IGNORECASE)
    return bool(m and m.group(1).upper() == "ON")


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--ramp-min-mv", type=float, default=-1400.0)
    p.add_argument("--ramp-max-mv", type=float, default=1400.0)
    p.add_argument("--ramp-step-mv", type=float, default=1.0)
    p.add_argument("--timeout-s", type=float, default=30.0,
                   help="Run duration in seconds; 0 means run until Ctrl-C.")
    args = p.parse_args()

    if args.ramp_min_mv >= args.ramp_max_mv:
        sys.exit("ramp-min-mv must be smaller than ramp-max-mv.")
    if max(abs(args.ramp_min_mv), abs(args.ramp_max_mv)) > HARD_DAC_LIMIT_MV:
        sys.exit(f"Ramp exceeds hard DAC limit of +/-{HARD_DAC_LIMIT_MV:.0f} mV.")

    log("=== Pockels-cell characterization run ===")
    print("Confirm before continuing:\n"
          "  - HV cables connected, amplifier grounded and powered\n"
          "  - chiller ON, no leaks\n"
          "  - photodiode powered and aligned\n"
          "  - PicoScope open and recording")
    if input("Type 'yes' to continue: ").strip().lower() != "yes":
        sys.exit("Operator aborted.")

    try:
        log("Configuring and enabling DPS3005.")
        dps("set-voltage", f"{SUPPLY_V:.2f}")
        dps("set-current", f"{SUPPLY_A:.3f}")
        dps("on")
        if not supply_is_on():
            raise RuntimeError("DPS3005 did not report output ON; aborting before HV drive.")

        log(f"Starting ramp {args.ramp_min_mv:.0f} to {args.ramp_max_mv:.0f} mV, "
            f"step {args.ramp_step_mv:.1f} mV.")
        dac("--mode", "ramp_on",
            "--ramp_min_mv", args.ramp_min_mv,
            "--ramp_max_mv", args.ramp_max_mv,
            "--ramp_step_mv", args.ramp_step_mv)

        log("Cell is being driven -- record the full trace on the PicoScope.")
        if args.timeout_s <= 0:
            log("Running until Ctrl-C.")
            while True:
                time.sleep(1.0)
        else:
            log(f"Running for {args.timeout_s:.0f} s.")
            time.sleep(args.timeout_s)

    except KeyboardInterrupt:
        log("Interrupted by operator.")
    finally:
        log("Safe shutdown: stopping ramp and switching supply off.")
        dac("--mode", "ramp_off", check=False)
        dps("off", check=False)
        log("Done. Switch off amplifier, photodiode, and chiller manually.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
