
"""
ELL14 π/2 rotation test
Performs:
  - Reset controller
  - Initialize (home)
  - Move 90° (π/2 radians)
  - Query position before and after
"""
import sys
sys.path.append("/home/petalinux/fpga_lab_sprint/python/zedboard_pkgs")
import serial
import time

PORT = "/dev/ttyUSB0"
BAUD = 9600

def send(ser, cmd, delay=0.1):
    """Send command and print response."""
    ser.write(cmd.encode('ascii'))
    time.sleep(delay)
    resp = ser.read_all().decode(errors='ignore').strip()
    print(f"{cmd} -> {resp}")
    return resp

def main():
    ser = serial.Serial(PORT, baudrate=BAUD, timeout=0.5)
    print(f"Opened {ser.name} at {BAUD} baud")

    # --- Reset and home ---
    send(ser, "0rs")
    time.sleep(1)
    send(ser, "0in")  # Initialize (home)
    time.sleep(5)

    print("\n--- Query initial position ---")
    send(ser, "0gp")

    # --- Move π/2 radians (90°) = 1024 steps = 0x0400 ---
    print("\n--- Move π/2 radians (90°) ---")
    send(ser, "0ma0400")
    time.sleep(3)
    send(ser, "0gp")

    print("\n--- Move back to home (0°) ---")
    send(ser, "0ma0000")
    time.sleep(3)
    send(ser, "0gp")

    ser.close()
    print("\nSequence complete.")

if __name__ == "__main__":
    main()
