#!/tmp/sh
# ---- original sony script ---
# LMU AS3676 Configuration for Chargemon
dev=/sys/class/leds
echo 0 > $dev/lcd-backlight/als/enable  #Sensor on/off. 1 = on, reg 90h
echo 20000 > $dev/lcd-backlight/max_current
echo 2000 > $dev/red/max_current
echo 2000 > $dev/green/max_current
echo 2000 > $dev/blue/max_current
# ----- end of sony script ---

prepare_start () {
	# remount rootfs rw
	mount -o remount,rw /

	# stop services
	#
	echo "**** PL: stop services ****" > /dev/kmsg
	# stop doesn't seem to work at this boot state, we should check why
	/system/bin/stop secchan > /dev/kmsg
	/system/bin/stop ueventd > /dev/kmsg
	/system/bin/stop tad > /dev/kmsg
	/system/bin/stop adbd > /dev/kmsg
	/system/xbin/killall -9 ueventd 2> /dev/kmsg
	/system/xbin/killall -9 secchand 2> /dev/kmsg
	/system/xbin/killall -9 tad 2> /dev/kmsg
	echo "***** PL: ps after stop : ****" > /dev/kmsg
	ps > /dev/kmsg

	# unmounting and cleaning
	## /data/idd
	umount -l /dev/block/mmcblk0p10
	## /data
	umount -l /dev/block/mmcblk0p14
	## /cache
	umount -l /dev/block/mmcblk0p13
	## /sdcard
	umount -l /mnt/sdcard
	umount -l /sdcard
	umount -l /dev/block/mmcblk0p15
	
	## try hard way
	umount -f /data/idd
	umount -f /data
	umount -f /cache
	umount -f /system
	
	## paranoid ?
	umount /data/idd
	umount /data
	umount /cache
	umount /system
	umount /storage/sdcard0
	
	echo "***** PL: umount result: *****" > /dev/kmsg
	mount > /dev/kmsg

	## miscs
	umount /dev/cpuctl
	umount /acct
	umount /dev/pts
	umount /dev
	umount /mnt/asec
	umount /mnt/oob
	umount /proc

	# clean /
	cd /
	rm -r /sbin
	rmdir /sdcard
	rm -f etc init* uevent* default*
}

# ----- start the fun :) ------
export PATH=/tmp

echo "*** PL: starting cm/recovery boot script ***" > /dev/kmsg

# Show blue led
echo '255' > /sys/class/leds/blue/brightness
echo '0' > /sys/class/leds/red/brightness
echo '0' > /sys/class/leds/green/brightness

# Trigger vibration
echo '250' > /sys/class/timed_output/vibrator/enable

# wait for vol+/vol- keys 
cat /dev/input/event0 > /dev/keycheck&
cat /dev/input/event3 > /dev/keycheck2&
sleep 3
kill -9 $!

# vol+, boot recovery
if [ -s /dev/keycheck -o -e /cache/recovery/boot ]
then
    # trigger green LED
    echo '0' > /sys/class/leds/blue/brightness
    echo '0' > /sys/class/leds/red/brightness
    echo '255' > /sys/class/leds/green/brightness
    sleep 1

    rm /cache/recovery/boot

    prepare_start
    if [ -f /tmp/recovery.tar ]
    then
	tar -xf /tmp/recovery.tar
	rm /tmp/recovery.tar
	rm /tmp/cm.tar
    fi

    # trigger red LED
    echo '0' > /sys/class/leds/blue/brightness
    echo '128' > /sys/class/leds/red/brightness
    echo '0' > /sys/class/leds/green/brightness
    sleep 1

    # chroot
    chroot / /init
fi


# show violet debug led
echo '255' > /sys/class/leds/blue/brightness               
echo '255' > /sys/class/leds/red/brightness               
echo '0' > /sys/class/leds/green/brightness
sleep 1

prepare_start

# extract cm initramfs
if [ -f /tmp/cm.tar ]
then
    tar -xf /tmp/cm.tar
    rm /tmp/cm.tar
    rm /tmp/recovery.tar
fi

# normal boot, clear led
echo '0' > /sys/class/leds/blue/brightness
echo '0' > /sys/class/leds/red/brightness
echo '0' > /sys/class/leds/green/brightness

# chroot
chroot / /init
