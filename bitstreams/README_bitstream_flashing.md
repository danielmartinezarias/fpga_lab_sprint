# Flashing a bitstream

1. sudo chmod +x fpga-bit-to-bin.py
2. ./fpga-bit-to-bin.py -f BITSTREAM_FILE.bit  BITSTREAM_FILE.bit.bin
3. sudo fpgautil -o pl.dtbo (just once)
4. sudo fpgautil -b BITSTREAM_FILE.bit.bin -f Full

