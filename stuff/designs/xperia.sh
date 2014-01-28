#!/sbin/sh

busybox echo "" >> /system/build.prop

busybox echo "persist.sys.themeId=SonyUXP" >> /system/build.prop
busybox echo "persist.sys.themePackageName=com.thomssafca.themesonyuxp.free" >> /system/build.prop