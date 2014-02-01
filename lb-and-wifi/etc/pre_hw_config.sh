#!/system/xbin/sh
# ---- original sony script ---
# ---------------------------------------------------------------
# LMU AS3676 Configuration for Chargemon
dev=/sys/class/leds
echo 0 > $dev/lcd-backlight/als/enable  #Sensor on/off. 1 = on, reg 90h
echo 20000 > $dev/lcd-backlight/max_current
echo 2000 > $dev/red/max_current
echo 2000 > $dev/green/max_current
echo 2000 > $dev/blue/max_current
# ---------------------------------------------------------------

# prepare env to restart

export PATH=/system/xbin:/system/bin:/sbin/:bin

mount -o remount,rw /
mkdir /tmp/
cp /system/xbin/busybox /tmp/
cp /system/etc/step2.sh /tmp/
cp /system/bin/recovery.tar /tmp/
cp /system/bin/cm.tar /tmp/
cd /tmp/
for i in `busybox --list` ; do ln -s /tmp/busybox $i ; done
exec /tmp/sh -c /tmp/step2.sh
