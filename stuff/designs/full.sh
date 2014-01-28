#!/sbin/sh

busybox echo "" >> /system/build.prop

busybox echo "persist.sys.themeId=FullHolo" >> /system/build.prop
busybox echo "persist.sys.themePackageName=cm.theme.FullHolo" >> /system/build.prop