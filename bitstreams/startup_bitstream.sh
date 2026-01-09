sudo chmod +x /home/petalinux/bitstreams/fpga-bit-to-bin.py
./home/petalinux/bitstreams/fpga-bit-to-bin.py -f /home/petalinux/bitstreams/des
sudo fpgautil -o /home/petalinux/bitstreams/pl.dtbo
sudo fpgautil -b /home/petalinux/bitstreams/BITSTREAM_FILE.bit.bin -f Full
cd /home/petalinux/python
export FPGA_MODEL='ZedBoard2'
sudo touch "FPGA_MODEL=$FPGA_MODEL" >> /etc/environment
sudo -E python3 scripts/version.py
