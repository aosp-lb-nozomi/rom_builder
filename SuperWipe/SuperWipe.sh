#!/sbin/sh

## SuperWipe
##modded by team marvelusc
#wipes all data for good, nothing is left
## Default Configuration
# Cannot be blank (yes or No)
Wipe_Cache=yes
Wipe_Userdata=yes
Wipe_System=yes
Wipe_Boot=yes
Wipe_Sd_Ext=yes
Wipe_Sd_Secure=yes
#
##


## SuperWipe Variables
#
SuperWipe=/tmp/SuperWipe/erase_image
SuperWipe_SD="busybox rm -rf"
Cus_Conf_Location=/sdcard/SuperWipe.conf
Write_log=/sdcard/SuperWipe.log 
#
##


## Mount Sdcard and check for Custom Configurations
#
Check_for_Custom_Configurations () {
busybox mount | grep /sdcard >/dev/null
	if [ $? = 1 ]; then
		busybox mount /sdcard >/dev/null
	fi
if [ -f $Cus_Conf_Location ];then 
	. $Cus_Conf_Location 
		if [ $Log_2_Sdcard = yes ];then 
			Write_log=/sdcard/SuperWipe.log
			echo "" ## Mark title and date for log
			echo "       SuperWipe log" >>$Write_log
			date >>$Write_log;echo "" >>$Write_log				
		fi		
	echo "(Using Custom Configuration)" >>$Write_log
else
	echo "" ## Mark title and date for log
	echo "       SuperWipe log" >>$Write_log
	date >>$Write_log;echo "" >>$Write_log
	echo "(Using Default configuration)" >>$Write_log
fi
}
Check_for_Custom_Configurations ;
# Custom Configurations
##


## SuperWipe Cache Partition
#
SuperWipe_Cache () {
if [ $Wipe_Cache = yes ];then
	$SuperWipe cache
	if [ $? = 0 ] ; then 			
		echo "-SuperWipe Cache:      Successful" >>$Write_log
	else
		echo "-SuperWipe Cache:      Failed" >>$Write_log
	fi
else 
	echo "-SuperWipe Cache:      Skipped" >>$Write_log
fi
} 
SuperWipe_Cache ;
# Cache Partition
##


## SuperWipe Userdata Partition
#
SuperWipe_Userdata () {
if [ $Wipe_Userdata = yes ];then
	$SuperWipe userdata
	if [ $? = 0 ] ; then 			
		echo "-SuperWipe Userdata:   Successful" >>$Write_log
	else
		echo "-SuperWipe Userdata:   Failed" >>$Write_log
	fi
else
	echo "-SuperWipe Userdata:   Skipped" >>$Write_log
fi
} 
SuperWipe_Userdata ;
# Userdata Partition
##


## SuperWipe Boot Partition
#
SuperWipe_Boot () {
if [ $Wipe_Boot = yes ];then
	$SuperWipe boot
	if [ $? = 0 ] ; then 			
		echo "-SuperWipe Boot:       Successful" >>$Write_log
	else
		echo "-SuperWipe Boot:       Failed" >>$Write_log
	fi
else
	echo "-SuperWipe Boot:       Skipped" >>$Write_log
fi
} 
SuperWipe_Boot ;
# Boot Partition
##


## SuperWipe System Partition
#
SuperWipe_System () {
if [ $Wipe_System = yes ];then 
	$SuperWipe system
	if [ $? = 0 ] ; then 			
		echo "-SuperWipe System:     Successful" >>$Write_log
	else
		echo "-SuperWipe System:     Failed" >>$Write_log
	fi
else
	echo "-SuperWipe System:     Skipped" >>$Write_log
fi
}
SuperWipe_System ;
# System Partition
##


## SuperWipe sdcard/.android_secure
#
SuperWipe_Sd_Secure () {
if [ $Wipe_Sd_Secure = yes ];then 
	if [ -e /dev/block/mmcblk0p1 ]; then
			$SuperWipe_SD /sdcard/.android_secure/*
		if [ $? = 0 ] ; then 
			echo "-SuperWipe secure:     Successful" >>$Write_log
		else
			echo "-SuperWipe secure:     Failed" >>$Write_log
		fi
	else
		echo "-SuperWipe secure:     block not found" >>$Write_log
	fi	
else
	echo "-SuperWipe secure:     Skipped" >>$Write_log
fi	
}
SuperWipe_Sd_Secure ;
# So Fresh and So Clean
##


## SuperWipe sd-ext
# 
SuperWipe_Sd_Ext () {
if [ $Wipe_Sd_Ext = yes ];then 
	if [ -e /dev/block/mmcblk0p2 ]; then
		  busybox mount /sd-ext > /dev/null
			$SuperWipe_SD /sd-ext/*
			busybox umount /sd-ext > /dev/null
			busybox umount /sdcard > /dev/null
			e2fsck -pv /dev/block/mmcblk0p2 >>$Write_log
			ExitCode=$?
		if [ ${ExitCode} -lt 2 ] ; then 
			echo "-SuperWipe sd-ext:     Successful" >>$Write_log
		else
			echo "-SuperWipe sd-ext:     Failed (rc=${ExitCode})" >>$Write_log
		fi
	else
		echo "-SuperWipe sd-ext:     block not found" >>$Write_log
	fi	
else
	echo "-SuperWipe sd-ext:     Skipped" >>$Write_log
fi	
}
SuperWipe_Sd_Ext ;
# TODO: Wipe only specific folders
##

 
## Check sd-ext partition for errors
#
#echo "" >>$Write_log
#e2fsck -pv /dev/block/mmcblk0p2 >>$Write_log
#
## -Disabled for now-


## End of log
#
echo "        -END OF LOG-" >>$Write_log ;echo "" >>$Write_log
# End of log
##


## Reboot after use of SuperWipe
# Give a delay so you can read screen
if [ $Reboot_when_done = yes ];then 
	sleep $Reboot_Delay ;reboot recovery
fi
# Reboot with delay option
##

## Script by Ohsaka edited by simonsimons34@gmail.com
