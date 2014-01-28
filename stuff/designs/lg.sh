#!/sbin/sh

busybox echo "" >> /system/build.prop

busybox echo "persist.sys.themeId=LG Optimus" >> /system/build.prop
busybox echo "persist.sys.themePackageName=com.thomssafca.lgoptimus.free" >> /system/build.prop