[Zynq-7000 Embedded Design Tutorial, Getting Started](https://xilinx.github.io/Embedded-Design-Tutorials/docs/2023.1/build/html/docs/Introduction/Zynq7000-EDT/1-introduction.html)￼

￼## ZYNQ-7000 
The Zynq®-7000 SoC comes with a versatile processing system (PS) integrated with a highly flexible and high-performance programmable logic (PL) section, all on a single system-on-a-chip (SoC).

￼## What to use
Vivado can describe the hardware design, including code editing, synthesis, implementation, simulation and binary generation, but no software. Vitis on the other hand can do both, and also deals with the OS. On the other hand, Petalinux can create a Linux image compatible with Zynq.
￼## What's Petalinux?
The PetaLinux tools offer everything necessary to customize, build, and deploy embedded Linux solutions on Xilinx processing systems.

￼## Steps to create a PetaLinux image from a .xsa file

1. In Vivado, Generate Bitstream, then File -> Export -> Export Hardware (include bitstream). That will generate the .xsa file
2. Go to the Walther-could -> login -> Lens -> Coder -> Workspace -> PetalinuxDaniel or whatever workspace -> VNC Desktop (CRUCIAL)
3. If Petalinux is already installed, run
```
source /opt/Xilinx/petalinux/settings.sh
```
If it is not installed , just follow `/accept-eula.sh /petalinux-v2023.2-10121855-installer.run /opt/Xilinx/petalinux` 
4. Set the `PROJECT_NAME` variable
```
export PROJECT_NAME='the_name_you_want'
``` 
5. In a LOCAL folder like `/home/kasm-user/petalinux_images/` (not `multi-photon`) start a new project from a template with the following commands 
```
DISTRO='petalinux' petalinux-create --type project --name $PROJECT_NAME --template zynq
```
5. Now configure Petalinux
```
DISTRO='petalinux' petalinux-config --get-hw-description PATH_TO_THE_XSA.xsa --project $PROJECT_NAME
```
A new window will pop up. Configure this:
- `[FPGA-Manager]`: enabled
- ```[Image Packaging Configuration --->] [Root filesystem type (xxxx) --->]```
change it to `EXT4 (SD/eMMC/SATA/USB)`
- You can also change the Boot Configuration in `[Subsystem AUTO Hardware Settings --->`, e.g. the MAC address that is used by the Board.
Save and exit

It is time to configure rootfs,
```
DISTRO='petalinux' petalinux-config -c rootfs --project $PROJECT_NAME
```
-  Include python3: `[Filesystem Packages] ---> misc ---> python3 --->mmap, datetime,threading,json`
- Include python3-numpy: `[Filesystem Packages] ---> devel ---> python3-numpy`
-  Include git: `[Filesystem Packages] ---> console ---> utils ---> git`
- Include dropbear: `[Filesystem Packages] ---> console ---> network ---> dropbear`
- Add users: `[Petalinux RootFS Settings] --->` `Add Extra Users`, use this:
`root:root;petalinux:;`

Save and exit
Configure the kernel: 

