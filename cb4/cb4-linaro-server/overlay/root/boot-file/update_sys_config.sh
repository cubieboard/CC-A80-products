#!/bin/bash

/bin/busybox unix2dos  sys_config.fex
/bin/cubie-fex2bin sys_config.fex sys_config.bin
/bin/busybox dos2unix  sys_config.fex
/bin/cubie-uboot-spl u-boot-spl.bin sys_config.bin u-boot-spl_with_sys_config.bin
sudo dd if=u-boot-spl_with_sys_config.bin of=/dev/mmcblk0 bs=1024 seek=8
rm -rf u-boot-spl_with_sys_config.bin

if [ $1 = "tfcard" ];then

	/bin/cubie-uboot u-boot-sun9iw1p1.bin sys_config.bin u-boot-sun9iw1p1_with_sys_config.bin
	sudo dd if=u-boot-sun9iw1p1_with_sys_config.bin  of=/dev/mmcblk0   bs=1024 seek=19096

	rm -rf u-boot-sun9iw1p1_with_sys_config.bin 
	echo ""
        echo "_______________________________________________________________________________________________________________________"
	echo ""
	echo "if select wrong parameter,can't boot the system after reboot,so should execute the script again with correct parameter"
	echo "see readme.txt for more details"
	echo ""
        echo "_______________________________________________________________________________________________________________________"
	echo ""
elif [ $1 = "emmc" ];then


	/bin/cubie-uboot   u-boot-sun9iw1p1_card2.bin sys_config.bin u-boot-sun9iw1p1_card2_with_sys_config.bin
	sudo dd if=u-boot-sun9iw1p1_card2_with_sys_config.bin  of=/dev/mmcblk0  bs=1024 seek=19096
	rm -rf u-boot-sun9iw1p1_card2_with_sys_config.bin

        echo ""
        echo "_______________________________________________________________________________________________________________________"
        echo ""
        echo "if select wrong parameter,can't boot the system after reboot,so should execute the script again with correct parameter"
	echo "see readme.txt for more details"
        echo ""
        echo "_______________________________________________________________________________________________________________________"
        echo ""




else   
     echo ""
     echo ""
     echo "update fail!"
     echo "please indicate tfcard or emmc"
     echo "for example:./update_sys_config.sh tfcard"
     echo ""
     echo ""


fi

