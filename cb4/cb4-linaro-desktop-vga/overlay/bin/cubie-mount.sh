#!/bin/sh


mkdir -p /media/$1
/bin/mount -o uid=1000,gid=1000 /dev/$1 /media/$1


if [ $? != 0 ]; then

echo ""  >/dev/ttyS0
echo ""  >/dev/ttyS0
echo ""  >/dev/ttyS0
echo  "\033[31m Can't mount the device ,please format it into available format,like VFAT(FAT or FAT32 in Windows ) or EXT4. \033[0m" >/dev/ttyS0

echo ""  >/dev/tty0
echo ""  >/dev/tty0
echo ""  >/dev/tty0
echo  "\033[31m Can't mount the device ,please format it into available format,like VFAT(FAT or FAT32 in Windows ) or EXT4. \033[0m" >/dev/tty0

fi


