#!/sbin/sh

busybox echo "" >> /system/build.prop

busybox echo "persist.sys.themeId=Dust" >> /system/build.prop
busybox echo "persist.sys.themePackageName=cm.theme.Dust" >> /system/build.prop