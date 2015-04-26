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

# allow untrusted apps to read from debugfs
/system/xbin/supolicy --live \
	"allow untrusted_app debugfs file { open read getattr }" \
	"allow untrusted_app sysfs_lowmemorykiller file { open read getattr }" \
	"allow untrusted_app persist_file dir { open read getattr }" \
	"allow debuggerd gpu_device chr_file { open read getattr }" \
	"allow netd netd capability fsetid" \
	"allow netd { hostapd dnsmasq } process fork" \
	"allow { system_app shell } dalvikcache_data_file file write" \
	"allow { zygote mediaserver bootanim appdomain }  theme_data_file dir { search r_file_perms r_dir_perms }" \
	"allow { zygote mediaserver bootanim appdomain }  theme_data_file file { r_file_perms r_dir_perms }" \
	"allow system_server { rootfs resourcecache_data_file } dir { open read write getattr add_name setattr create remove_name rmdir unlink link }" \
	"allow system_server resourcecache_data_file file { open read write getattr add_name setattr create remove_name unlink link }" \
	"allow system_server dex2oat_exec file rx_file_perms" \
	"allow mediaserver mediaserver_tmpfs file execute" \
	"allow drmserver theme_data_file file r_file_perms" \
	"allow zygote system_file file write" \
	"allow atfwd property_socket sock_file write" \
	"allow untrusted_app sysfs_display file { open read write getattr add_name setattr remove_name }" \
	"allow debuggerd app_data_file dir search"

# Detectar si existe el directorio en /system/etc y si no la crea. - by Javilonas
#

if [ ! -d "/system/etc/init.d" ] ; then
mount -o remount,rw -t auto /system
mkdir /system/etc/init.d
chmod 0755 /system/etc/init.d/*
mount -o remount,ro -t auto /system
fi

# init.d support
/system/xbin/busybox run-parts /system/etc/init.d

# Iniciar SQlite
/res/ext/sqlite.sh

# Iniciar Zipalign
/res/ext/zipalign.sh

# Iniciar Tweaks
/res/ext/tweaks.sh


$BB sleep 1

# Aplicar Fstrim
$BB /sbin/fstrim -v /data
$BB /sbin/fstrim -v /cache
$BB /sbin/fstrim -v /system

$BB sync

$BB mount -t rootfs -o remount,ro rootfs
$BB mount -o remount,ro -t auto /system

