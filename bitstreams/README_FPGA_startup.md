# Startup config

## Add an enviromental variable
1. `sudo vi /etc/environment` 
(Add this line to the end)
FPGA_MODEL='ZedBoard'
2. `vi ~/.bashrc`
(Add these lines at the end)
```
source /etc/environment
PS1='\[\033[01;91m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
export LS_COLORS='di=01;34:ln=01;36:ex=01;32:*.tar=01;31:*.zip=01;31:*.jpg=01;35:*.png=01;35'
```



## Configure ssh
Since petalinux user has no password, we need to adjust ssh settings to access our system
1. `sudo vi /etc/ssh/sshd_config`
2. Add this lines to the end (or uncomment and change the arg)
`PasswordAuthentication yes
PermitEmptyPasswords yes`
3. Restart sshd
```
sudo killall sshd
/usr/sbin/sshd
```
4. `ip a` to know your ip address, on eth0, inet 192.168....
5. from a remote computer in the same network try to acccess
`ssh petalinux@(zedboard IP)`
6. Send date
`ssh petalinux@(zedboard IP) sudo date -s @$(date -u +"%s")`

## Clone this repo
1. `git clone https://github.com/danielmartinezarias/fpga_lab_sprint.git`

## To automatically flash the bitstream after reboot

1. `sudo vi /etc/init.d/startup_bitstream.sh`
(Must be this)
```
#!/bin/sh
### BEGIN INIT INFO
# Provides:          startup_bitstream
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: flashing bitsteam after login
### END INIT INFO
/home/petalinux/startup_bitstream.sh
```
2. Run these lines
```
sudo sh -c 'echo "export FPGA_MODEL=ZedBoard" >> /etc/profile'
cp fpga_lab_sprint/bitstreams/startup_bitstream.sh .
chmod +x startup_bitstream.sh
sudo chmod +x /etc/init.d/startup_bitstream.sh
sudo update-rc.d startup_bitstream.sh defaults
sudo reboot
```
## Install python packages





Now the Zedboard should boot with the most recent bitstream and users can access to the Zedboard remotely 