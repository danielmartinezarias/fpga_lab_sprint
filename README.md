# Grab and go FPGA projects
In this repository you can find a number of FPGA templates to build a laboratory control system. 

The control system relies on the FPGA-Linux-Python synergy. Here you will find a **Vivado FPGA project, a Petalinux boot image, and a Python enviroment** to control your FPGA modules.

## FPGA boards
The templates are targeted to the following boards:
1. Zedboard

## Modules
Find these interesting modules for an optics related laboratory:
- Time Tagger
- UART communication
- DAC driver
- ADC driver
- ELL (Thorlabs)
- GPS

### Time Tagger
Based on the work in Michael Adamic's [zynq_tdc](https://github.com/madamic/zynq_tdc.git) time to digital converter. 

# How to use this repository?
1. Generate a Vivado project by ruuning this command:
```
vivado -mode batch -source FPGA/make_project.tcl
```
This will create a project that you can modify and work with. 
