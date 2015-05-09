#!/bin/bash
#
# Configuration

card="mmcblk1"
FORMAT=yes
LED1_TRIGGER="/sys/class/leds/red:ph06:led1/trigger"
LED2_TRIGGER="/sys/class/leds/green:ph17:led2/trigger"

LED1_BRIGHT="/sys/class/leds/red:ph06:led1/brightness"
LED2_BRIGHT="/sys/class/leds/green:ph17:led2/brightness"
BOOT_FILE="/root/boot-file/"
ERROR_LOG="/root/error_log.txt"
INSTALL_EMMC_FILE="/root/install_emmc.sh"
BACK_EMMC_FILE="/root/backup_emmc_to_sd.sh"



start()
{
        echo "timer" > ${LED1_TRIGGER}
        return 0
}

led_when_err()
{
        echo "none" > ${LED1_TRIGGER}
        echo 1 > ${LED1_BRIGHT}
        echo "timer" > ${LED2_TRIGGER}
        exit 0
}

part_card()
{
        umount /dev/mmcblk1p*
        umount /dev/mmcblk0p*
fdisk /dev/$card <<EOF
o
n
p
1
40960
65535
n
p
2
65536

w
EOF

        if [ $? -ne 0 ]; then
                echo "err in sfdisk" > ${ERROR_LOG}
                led_when_err
        fi

        sync
        mkfs.vfat /dev/${card}p1
        if [ $? -ne 0 ]; then
                echo "err in mkfs p1" > ${ERROR_LOG}
                led_when_err


        fi
        echo y | mkfs.ext4 /dev/${card}p2
        if [ $? -ne 0 ]; then
                echo "err in mkfs p2" > ${ERROR_LOG}
                led_when_err
        fi


}

install_emmc()
{
        mkdir -p  /mnt/emmc
        if [ $? -ne 0 ]; then
                echo "err in mkdir  emcc" > ${ERROR_LOG}
                led_when_err
        fi

        mkdir -p  /mnt/card
        if [ $? -ne 0 ]; then
                echo "err in mkdir  card" > ${ERROR_LOG}
                led_when_err
        fi

        mount /dev/${card}p1    /mnt/emmc
        if [ $? -ne 0 ]; then
                echo "err in mount emmc p1" > ${ERROR_LOG}
                led_when_err
        fi
        mount /dev/mmcblk0p1    /mnt/card
        if [ $? -ne 0 ]; then
                echo "err in mount card p1" > ${ERROR_LOG}
                led_when_err
        fi
        cp /mnt/card/uImage /mnt/emmc
        sync
        umount /mnt/card/ /mnt/emmc

        mount /dev/${card}p2    /mnt/emmc
        if [ $? -ne 0 ]; then
                echo "err in mount emmc p2" > ${ERROR_LOG}
                led_when_err
        fi

	echo "Creating hard drive rootfs ... up to 5 mins"
	rsync -aH --exclude-from=/root/boot-file/.install-exclude  /  /mnt/emmc
        #(cd /mnt/card; sudo tar  --exclude mnt -cp  *) |sudo tar -C  /mnt/emmc -xmp
	if [ -f ${INSTALL_EMMC_FILE} ]; then
		cp ${INSTALL_EMMC_FILE} /mnt/emmc${BACK_EMMC_FILE}
		sed -i '148s/_card2//' /mnt/emmc${BACK_EMMC_FILE} 
		sed -i '196s/your emmc flash/your Micro SD Card/' /mnt/emmc${BACK_EMMC_FILE} 
		sed -i '196s/of Micro SD Card/of emmc flash/' /mnt/emmc${BACK_EMMC_FILE} 
		sed -i '220s/emmc flash without //' /mnt/emmc${BACK_EMMC_FILE} 
	
	fi
	if [ -f ${BACK_EMMC_FILE} ]; then
		cp ${BACK_EMMC_FILE} /mnt/emmc${INSTALL_EMMC_FILE}
		sed -i '148s/u-boot-sun9iw1p1.bin/u-boot-sun9iw1p1_card2.bin/' /mnt/emmc${INSTALL_EMMC_FILE} 
		sed -i '196s/your Micro SD Card/your emmc flash/' /mnt/emmc${INSTALL_EMMC_FILE} 
		sed -i '196s/of emmc flash/of Micro SD Card/' /mnt/emmc${INSTALL_EMMC_FILE} 
		sed -i '220s/the Micro SD Card/emmc flash without the Micro SD Card/' /mnt/emmc${INSTALL_EMMC_FILE} 
	
	fi

        sed -i 's/install_emmc.sh/ /g' /mnt/emmc/etc/init.d/rcS
        sed -i 's/powroff/ /g' /mnt/emmc/etc/init.d/rcS
        sed -i 's/shutdown/ /g' /mnt/emmc/etc/init.d/rcS
        sync
        umount /mnt/emmc  /mnt/card
        rm -fr  /mnt/emmc /mnt/card

        /bin/busybox unix2dos  ${BOOT_FILE}/sys_config.fex
        /bin/cubie-fex2bin ${BOOT_FILE}/sys_config.fex ${BOOT_FILE}/sys_config.bin
        /bin/busybox dos2unix  ${BOOT_FILE}/sys_config.fex
        /bin/cubie-uboot-spl ${BOOT_FILE}/u-boot-spl.bin ${BOOT_FILE}/sys_config.bin ${BOOT_FILE}/u-boot-spl_with_sys_config.bin


        sudo dd if=${BOOT_FILE}/u-boot-spl_with_sys_config.bin of=/dev/${card} bs=1024 seek=8
        if [ $? -ne 0 ]; then
                echo "err in dd u-boot-spl" >  ${ERROR_LOG}/error_log.txt
                led_when_err
        fi

        rm -f ${BOOT_FILE}/u-boot-spl_with_sys_config.bin
        /bin/cubie-uboot ${BOOT_FILE}/u-boot-sun9iw1p1_card2.bin ${BOOT_FILE}/sys_config.bin ${BOOT_FILE}/u-boot-sun9iw1p1_with_sys_config.bin
        sudo dd if=${BOOT_FILE}/u-boot-sun9iw1p1_with_sys_config.bin  of=/dev/${card}   bs=1024 seek=19096
        if [ $? -ne 0 ]; then
                echo "err in dd u-boot-spl" >  ${ERROR_LOG}/error_log.txt
                led_when_err
        fi

        rm -f ${BOOT_FILE}/u-boot-sun9iw1p1_with_sys_config.bin

        return 0
}

shutdown()
{
        poweroff
        return 0
}

clear_console
figlet -f banner "warning"
#echo "Edit file !!!"; exit 0; # DELETE OR COMMENT THIS LINE TO CONTINUE
#
#
# Do not modify anything below
#

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script."
    exit 1
fi

cat > /root/boot-file/.install-exclude <<EOF
/dev/*
/proc/*
/sys/*
/media/*
/mnt/*
/run/*
/tmp/*
/root/deb
/root/install_emmc.sh
/root/backup_emmc_to_sd.sh
EOF

clear_console
figlet -f banner "warning"

echo " This script might erase your emmc flash and copy content of Micro SD Card to it . "




echo -n "Proceed (y/n)? (default: n): "
read emmcinst

if [ "$emmcinst" != "y" ]
then
  exit 0
fi


if [ "$FORMAT" == "yes" ]
then
	part_card

	install_emmc
fi

figlet -f banner "notice"
echo ""
echo ""
echo "All done. System can boot directly from emmc flash without the Micro SD Card ."
echo ""
echo ""
rm /root/boot-file/.install-exclude


