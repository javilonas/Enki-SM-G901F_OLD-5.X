#!/system/bin/sh
#
# Tweaks - by Javilonas
#

# CACHE AUTO CLEAN
echo "3" > /proc/sys/vm/drop_caches

# Miscellaneous tweaks
echo "5" > /proc/sys/vm/laptop_mode
echo "8" > /proc/sys/vm/page-cluster

echo "0" > /proc/sys/kernel/randomize_va_space

echo "50" > /sys/module/zswap/parameters/max_pool_percent

# Activar dynamic FSync
echo "1" > /sys/kernel/dyn_fsync/Dyn_fsync_active

# reduce txqueuelen to 0 to switch from a packet queue to a byte one
NET=`ls -d /sys/class/net/*`
for i in $NET 
do
echo "0" > $i/tx_queue_len

done

LOOP=`ls -d /sys/block/loop*`
RAM=`ls -d /sys/block/ram*`
MMC=`ls -d /sys/block/mmc*`
ZSWA=`ls -d /sys/block/vnswap*`
for j in $LOOP $RAM $MMC $ZSWA
do 
echo "0" > $j/queue/rotational
echo "2048" > $j/queue/read_ahead_kb; 

done

echo "2048" > /sys/devices/virtual/bdi/179:0/read_ahead_kb;

# Turn off debugging for certain modules
echo "0" > /sys/module/alarm_dev/parameters/debug_mask
echo "0" > /sys/module/binder/parameters/debug_mask
echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
echo "0" > /sys/module/kernel/parameters/initcall_debug
echo "0" > /sys/module/xt_qtaguid/parameters/debug_mask

# Otros Misc tweaks(REV 2.0 BY JAVILONAS)
mount -t debugfs none /sys/kernel/debug
echo "NO_NORMALIZED_SLEEPER NO_GENTLE_FAIR_SLEEPERS NO_START_DEBIT NEXT_BUDDY LAST_BUDDY CACHE_HOT_BUDDY CACHE_HOT_BUDDY NO_WAKEUP_PREEMPTION ARCH_POWER NO_HRTICK NO_DOUBLE_TICK LB_BIAS NONTASK_POWER TTWU_QUEUE NO_FORCE_SD_OVERLAP RT_RUNTIME_SHARE NO_LB_MIN SYNC_WAKEUPS" > /sys/kernel/debug/sched_features

# Fix para problemas Con aplicaciones
/system/xbin/busybox setprop ro.kernel.android.checkjni 0

/system/xbin/busybox setprop ro.HOME_APP_ADJ -17

# Desactivar fast Dormancy
/system/xbin/busybox setprop ro.semc.enable.fast_dormancy false

# Tiempo de escaneado wifi (ahorra + batería)
/system/xbin/busybox setprop wifi.supplicant_scan_interval 480

