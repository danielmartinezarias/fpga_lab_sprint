echo "--------------------------------------"
echo "Starting FPGA bitstream setup..."
echo "--------------------------------------"
echo "Flipping bitstream..."
sudo chmod +x /home/petalinux/fpga_lab_sprint/bitstreams/fpga-bit-to-bin.py
/home/petalinux/fpga_lab_sprint/bitstreams/fpga-bit-to-bin.py -f /home/petalinux/fpga_lab_sprint/bitstreams/design_1_wrapper.bit /home/petalinux/fpga_lab_sprint/bitstreams/design_1_wrapper.bit.bin
echo "--------------------------------------"
echo "Loading device tree overlay..."
echo "--------------------------------------"
sudo fpgautil -o /home/petalinux/fpga_lab_sprint/bitstreams/pl.dtbo
echo "--------------------------------------"
echo "Flashing FPGA bitstream..."
echo "--------------------------------------"
sudo fpgautil -b /home/petalinux/fpga_lab_sprint/bitstreams/design_1_wrapper.bit.bin -f Full
echo "--------------------------------------"
echo "Setting FPGA model environment variable..."
echo "--------------------------------------"
echo "FPGA_MODEL=$FPGA_MODEL"
echo "--------------------------------------"
echo "Reading version using Python..."
echo "--------------------------------------"
cd /home/petalinux/fpga_lab_sprint/python
sudo -E python3 scripts/version.py
echo "--------------------------------------"
echo "FPGA bitstream setup complete."
echo "--------------------------------------"
