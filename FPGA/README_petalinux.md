[Zynq-7000 Embedded Design Tutorial, Getting Started](https://xilinx.github.io/Embedded-Design-Tutorials/docs/2023.1/build/html/docs/Introduction/Zynq7000-EDT/1-introduction.html)

## ZYNQ-7000 
The Zynq®-7000 SoC comes with a versatile processing system (PS) integrated with a highly flexible and high-performance programmable logic (PL) section, all on a single system-on-a-chip (SoC).

## What to use
Vivado can describe the hardware design, including code editing, synthesis, implementation, simulation and binary generation, but no software. Vitis on the other hand can do both, and also deals with the OS. On the other hand, Petalinux can create a Linux image compatible with Zynq.
## What's Petalinux?
The PetaLinux tools offer everything necessary to customize, build, and deploy embedded Linux solutions on Xilinx processing systems.

## Steps to create a PetaLinux image from a .xsa file

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
```
DISTRO='petalinux' petalinux-config -c kernel --project $PROJECT_NAME
```  
No need to change something in the configuration

Configure the Device-Tree ,this step is needed because it generates `.dtsi` and `.dtbo` files
```
DISTRO='petalinux' petalinux-config -c device-tree --project $PROJECT_NAME
```

7. Build
```
DISTRO="petalinux' petalinux-build --project $PROJECT_NAME/
```

8. Package
```
petalinux-package --boot --format BIN --fsbl images/linux/zynq_fsbl.elf --u-boot --project $PROJECT_NAME
```

9. Create SD card files
```
cd $PROJECT_NAME
DISTRO="petalinux" petalinux-package --wic
```
this will output a `images/linux/petalinux-sdimage.wic` file (basically a sd card image on a file).

10. This file is in the server, take it to your computer
```
scp coder.fpga-lab-sprint:/home/kasm-user/github/fpga_lab_sprint/FPGA/PROJECT_NAME/images/linux/petalinux-sdimage.wic github/fpga_lab_sprint/FPGA/outputs/
```
It is a big file ~6GB

11. Format an SD card to EXT4, 8GB
12. Write the disk
```
sudo dd if=github/fpga_lab_sprint/FPGA/outputs/petalinux-sdimage.wic of=/dev/sdc bs=4M status=progress conv=fsync
```
Wait patiently. It takes like 20 min

13. Plug the SD card and Boot the Zedboard, don't forget to set the jumpers m05 and m06 to 3V3 and the rest to gnd ![[Pasted image 20240508160918.png]]
14. Find the tty port where Zedboard UART is connected.
```
sudo dmesg | grep tty
```
Outputs is ttyACM0, tty0, etc.
15. Use `picocom` to access Zedboard terminal
```
sudo picocom -b 115200 /dev/ttyACM0
```
15. Set a password

## Zedboard terminal access via Ethernet
### On TeraTerm
1. Edit your network config, 
2. if it eth0 is not 192.168.1.1 type` sudo vi /etc/network/interfaces` and change it, also set static  instead of dhcp automatic. Should look like this 
**Wireless interfaces** 
iface wlan0 inet dhcp
        wireless_mode managed
        wireless_essid any
        wpa-driver wext
        wpa-conf /etc/wpa_supplicant.conf

iface atml0 inet dhcp

**Wired or wireless interfaces**
auto eth0
iface eth0 inet static
        address 192.168.1.1
        netmask 255.255.255.0
iface eth1 inet dhcp
3. Toggle on and off ethernet `sudo ifup eth0` `sudo ifdown eth0` `sudo ifup eth0` 
4. Then copy your new ssh keys `cat /etc/ssh/ssh_host_rsa_key.pub` `cat /etc/ssh/ssh_host_ed25519_key.pub`


### On Windows Powershell 
1. go to windows powershell and copy the keys in `notepad .\.ssh\known_hosts`
2. Now in Windows you have access to the FPGA via ethernet. Set the second ethernet connector IP address to 192.168.1.2 and manual
3. Open a terminal and type `ssh petalinux@192.168.1.1`. Now you can access to the Zedboard terminal without TeraTerm. If it does not work, in a new terminal type `notepad .\.ssh\known_hosts` and overwrite the keys with the new ones. 
4. Copy any file with `scp .\design_1_wrapper.bin petalinux@192.168.1.1:/home/petalinux`, for instance your .bitnfile
5. Now use `fpgautil -b <bin file path> -o <dtbo file path>` .... to update the bin file 

### How to change the FPGA bitstream after PetaLinux is built
Special attention to [this youtube Xilinx PetaLinux tutorial](https://www.youtube.com/watch?v=k03r2Ud42jY) minute 16:08
Another full [tutorial](https://www.controlpaths.com/2023/04/08/configuring-pl-from-ps-in-zynq-mpsoc/) simple but effective
Full official Xilinx [tutorial](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841847/Solution+ZynqMP+PL+Programming#SolutionZynqMPPLProgramming-FPGAprogramming)
DTBO [info](https://xilinx.github.io/kria-apps-docs/creating_applications/2022.1/build/html/docs/dtsi_dtbo_generation.html)





# Some PetaLinux Commands

| Task | Command / Tool |
|------|----------------|
| **Hardware platform creation** (for custom hardware only) | AMD Vivado™ design tools |
| **Create a PetaLinux project** | `petalinux-create project` |
| **Initialize a PetaLinux project** (for custom hardware only) | `petalinux-config --get-hw-description` |
| **Configure system-level options** | `petalinux-config` |
| **Create user components** | `petalinux-create apps` <br> `petalinux-create modules` |
| **Configure U-Boot** | `petalinux-config -c u-boot` |
| **Configure the Linux kernel** | `petalinux-config -c kernel` |
| **Configure the root filesystem** | `petalinux-config -c rootfs` |
| **Build the system** | `petalinux-build` |
| **Package for deploying the system** | `petalinux-package` |
| **Boot the system for testing** | `petalinux-boot` |
| **Upgrade the workspace** | `petalinux-upgrade` |
| **Use Yocto devtools** | `petalinux-devtool` |
| **Use debug utilities** | `petalinux-util` |
