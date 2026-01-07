
set the enviromental variable:
sudo vi /etc/environment 
(add this line at the end)
FPGA_MODEL='ZedBoard'
exit (log out and login)

execute python as:
sudo -E python3 script.py
