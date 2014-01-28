#!/sbin/sh

busybox echo "" >> /system/build.prop

busybox echo "persist.sys.themeId=TranslucentCM" >> /system/build.prop
busybox echo "persist.sys.themePackageName=cm9.theme.TranslucentCM" >> /system/build.prop