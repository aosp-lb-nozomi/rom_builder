#!/sbin/sh

busybox echo "" >> /system/build.prop

busybox echo "persist.sys.themeId=TouchWiz" >> /system/build.prop
busybox echo "persist.sys.themePackageName=com.thomssafca.touchwiz.five.free" >> /system/build.prop