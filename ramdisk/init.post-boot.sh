#!/system/bin/sh

PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

BB=/sbin/busybox

# Inicio
$BB mount -o remount,rw -t auto /system
$BB mount -t rootfs -o remount,rw rootfs

if [ ! -f /system/xbin/busybox ]; then
$BB ln -s /sbin/busybox /system/xbin/busybox
fi

if [ ! -f /system/bin/busybox ]; then
$BB ln -s /sbin/busybox /system/bin/busybox
fi

/system/xbin/busybox --install -s /system/xbin

# KNOX Off
/res/ext/eliminar_knox.sh

# Detectar si existe el directorio en /system/etc y si no la crea. - by Javilonas
#

if [ ! -d "/system/etc/init.d" ] ; then
mount -o remount,rw -t auto /system
mkdir /system/etc/init.d
chmod 0755 /system/etc/init.d/*
mount -o remount,ro -t auto /system
fi

# Iniciar SQlite
/res/ext/sqlite.sh

# Iniciar Zipalign
/res/ext/zipalign.sh

# Iniciar Tweaks
/res/ext/tweaks.sh

/res/ext/smoothsystem.sh &
$BB renice 19 `pidof smoothsystem.sh`

$BB sleep 3

/res/ext/killing.sh &

$BB sleep 2

sync

# init.d support
/system/xbin/busybox run-parts /system/etc/init.d

$BB mount -t rootfs -o remount,ro rootfs
$BB mount -o remount,ro -t auto /system

