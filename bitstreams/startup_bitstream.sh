sudo chmod +x /home/petalinux/fpga_lab_sprint/bitstreams/fpga-bit-to-bin.py
./home/petalinux/fpga_lab_sprint/bitstreams/fpga-bit-to-bin.py -f /home/petalinux/bitstreams/des
sudo fpgautil -o /home/petalinux/fpga_lab_sprint/bitstreams/pl.dtbo
sudo fpgautil -b /home/petalinux/fpga_lab_sprint/bitstreams/BITSTREAM_FILE.bit.bin -f Full
cd /home/petalinux/fpga_lab_sprint/python
export FPGA_MODEL='ZedBoard'
sudo touch "FPGA_MODEL=$FPGA_MODEL" >> /etc/environment
sudo -E python3 scripts/version.py
