
=============================WIFI==============================================
The name of WIFI drive module is bcmdhd ,you can use command "lsmod " see that it has been loading . 
Use command "iwlist wlan0 scan" can find the WIFI hotspot you want to connect .
Add the ssid and passwd into /etc/network/interfaces .

Beacuse first connect ,after reboot the board ,maybe need type:

#ifconfig wlan0 down
#ifconfig wlan0 up
#/etc/init.d/networking restart 

=============================update sys_config.fex============================= 

sys_config.fex is a FEX file defines various aspects of how the SoC works. It configures the GPIO pins and sets up DRAM, Display, etc parameters.
Each line consists of a key = value pair combination under a [sectionheader].
All three,[sectionheader], key and value are case-sensitive. For comments a semi-colon (;) is used and everything following a semi-colon is ignored.
The chip does not parse a textual version of a fex file,it gets cleaned and compiled by a fex-compiler . 


After modified sys_config.fex ,excute the script update_sys_config.sh in the
directory boot-file.

If want to update the tfcar system ,use:
#./update_sys_config.sh tfcard

If want to update the emmc system ,use:
#./update_sys_config.sh emmc

Wait a moment.After executed it successful,please reboot the system.The
modification will be effective.
In order to prove the modification is effective ,you can change "heartbeat"to
"none".After the reboot ,the red LED is not bright.

If select wrong parameter,can't boot the system after reboot,so should execute
the script again with correct parameter.


=============================DISPLAY==========================================

The cubieboard4 can't support VGA and HDMI double display output at the same time .

To switch VGA  1024*768 display output :

#cd /root/boot-file
#cp vga_sys_config.fex sys_config.fex
#./update_sys_config.sh tfcard
#reboot

To switch HDMI 1080p60 display output :

#cd /root/boot-file
#cp hdmi_sys_config.fex sys_config.fex
#./update_sys_config.sh tfcard
#reboot


============================EMMC============================================

/root/install_emmc.sh can copy the whole system include the spl,uboot,kernel
and rootfs into the emmc ,which let the board boot system from emmmc .

