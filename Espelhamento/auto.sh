# Pause
read -r -p "AGUARDAR SISTEMA NO TABLET SUBIR E DESMONTAR SDCARD - Pressione [Enter] para continuar..." key

# Copiar parted
adb push parted /cache/recovery/parted
adb shell chmod 755 /cache/recovery/parted

# Formatar sdcard
adb push format-sdcard /cache/recovery/format-sdcard
adb shell sh /cache/recovery/format-sdcard

# Formatar partição adicional
adb shell make_ext4fs /dev/block/mmcblk0p15

# Reboot no recovery
adb reboot recovery

# Pause
read -r -p "AGUARDAR RECOVERY SUBIR (5s APOS O ROBOZINHO APARECER)- Pressione [Enter] para continuar..." key

#copiar busybox2
adb push busybox2 /cache
#adb shell chmod 755 /cache/busybox2

# Desmontar partições
adb shell /cache/busybox2 umount /data
adb shell /cache/busybox2 umount /metadata

# Copiar imagens para SDCARD
adb shell /cache/busybox2 dd if=/dev/block/rknand_parameter of=/dev/block/mmcblk0p1
adb shell /cache/busybox2 dd if=/dev/block/rknand_uboot of=/dev/block/mmcblk0p2
adb shell /cache/busybox2 dd if=/dev/block/rknand_misc of=/dev/block/mmcblk0p3
adb shell /cache/busybox2 dd if=/dev/block/rknand_resource of=/dev/block/mmcblk0p4
adb shell /cache/busybox2 dd if=/dev/block/rknand_kernel of=/dev/block/mmcblk0p5
#adb shell /cache/busybox2 dd if=/dev/block/rknand_boot of=/dev/block/mmcblk0p6
adb shell /cache/busybox2 dd if=/dev/block/rknand_recovery of=/dev/block/mmcblk0p7
adb shell /cache/busybox2 dd if=/dev/block/rknand_backup of=/dev/block/mmcblk0p8
adb shell /cache/busybox2 dd if=/dev/block/rknand_cache of=/dev/block/mmcblk0p9
adb shell /cache/busybox2 dd if=/dev/block/rknand_userdata of=/dev/block/mmcblk0p10
#adb shell /cache/busybox2 make_ext4fs /dev/block/mmcblk0p10
adb shell /cache/busybox2 dd if=/dev/block/rknand_metadata of=/dev/block/mmcblk0p11
#adb shell /cache/busybox2 make_ext4fs /dev/block/mmcblk0p11
adb shell /cache/busybox2 dd if=/dev/block/rknand_kpanic of=/dev/block/mmcblk0p12
adb shell /cache/busybox2 dd if=/dev/block/rknand_system of=/dev/block/mmcblk0p13
#adb shell /cache/busybox2 make_ext4fs /dev/block/mmcblk0p13
adb shell /cache/busybox2 dd if=/dev/block/rknand_user of=/dev/block/mmcblk0p14

# Copiar BOOT para SDCARD
adb push boot.img /cache/
adb shell /cache/busybox2 dd if=/cache/boot.img of=/dev/block/mmcblk0p6
adb shell /cache/busybox2 dd if=/cache/boot.img of=/dev/block/rknand_boot
adb shell /cache/busybox2 sync

# Pause
read -r -p "PROCEDIMENTO EXECUTADO COM SUCESSO - PODE REINICIAR O SISTEMA" key

