#!/bin/bash
export CB_BOARD=cubieboard8
export CB_KCONFIG=${CB_BOARD}_defconfig
export CB_FLASH_TSD_ROOTFS_SIZE=25
export CB_ROOTFS_IMAGE=${CB_ROOTFS_DIR}/linaro-desktop-trusty-cb4-14.04-v1.1.tar.gz
export CB_ROOTFS_SIZE=1500
export CB_FLASH_ROOTFS_IMAGE=${CB_ROOTFS_DIR}/card_flash_rootfs.tar.gz
export CB_U_BOOT_SPL_BIN=${CB_PACKAGES_DIR}/bin/u-boot-spl.bin
export CB_U_BOOT_SPL_BIN_OUTPUT=${CB_OUTPUT_DIR}/u-boot-spl.bin
export CB_U_BOOT_BIN=${CB_PACKAGES_DIR}/bin/u-boot-sun9iw1p1.bin
export CB_U_BOOT_BIN_OUTPUT=${CB_OUTPUT_DIR}/u-boot-sun9iw1p1.bin
export CB_U_BOOT_MMC2_BIN=${CB_PACKAGES_DIR}/bin/u-boot-sun9iw1p1_card2.bin
export CB_U_BOOT_MMC2_BIN_OUTPUT=${CB_OUTPUT_DIR}/u-boot-sun9iw1p1_card2.bin
export PATH=$PATH:${CB_PACKAGES_DIR}/cmd
export CROSS_COMPILE=arm-linux-gnueabihf-
