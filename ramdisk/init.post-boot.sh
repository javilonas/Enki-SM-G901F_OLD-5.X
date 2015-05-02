#!/system/bin/sh

PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

# Inicio
mount -o remount,rw -t auto /system
mount -t rootfs -o remount,rw rootfs

if [ ! -f /system/xbin/busybox ]; then
rm -rf /system/xbin/busybox
fi

if [ ! -f /system/bin/busybox ]; then
rm -rf /system/bin/busybox
fi

cp -f /sbin/busybox /system/xbin/busybox

/system/xbin/busybox --install -s /system/xbin

ln -s /system/xbin/busybox /system/bin/busybox

sync

# Asegurar Governor for Default
chmod 777 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "barry_allen" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor # CPU0
chmod -h 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod 777 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo "barry_allen" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor # CPU1
chmod -h 0664 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
chmod 777 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo "barry_allen" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor # CPU2
chmod -h 0664 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
chmod 777 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo "barry_allen" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor # CPU3
chmod -h 0664 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor

sync

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

sync

stop thermal-engine
/system/xbin/busybox run-parts /system/etc/init.d
start thermal-engine

mount -t rootfs -o remount,ro rootfs
mount -o remount,ro -t auto /system

