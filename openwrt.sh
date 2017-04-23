#/bin/bash -x
compile=`pwd`

echo "Quale versione vuoi compilare?"
echo "Scrivi BASE oppure HOTSPOT"
read VERSION

if [ $VERSION = "BASE" ]; then
   version='custom/openwrt-config-base'
fi
if [ $VERSION = "HOTSPOT" ]; then
   version='custom/openwrt-config-nodogspash'
fi

if [ -d openwrt ]; then
	cd openwrt && git pull
fi
if [ ! -d openwrt ]; then
        git clone -b chaos_calmer git://github.com/openwrt/openwrt.git source
fi


if [ -d $compile/Firmware/openwrt/$VERSION ]; then
        rm -rf $compile/Firmware/openwrt/$VERSION
fi
if [ ! -d $compile/Firmware/openwrt/$VERSION ]; then
        mkdir -p $compile/Firmware/openwrt/$VERSION
fi

cp $compile/source/feeds.conf.default $compile/source/feeds.conf
cat $compile/custom/feeds.conf >> $compile/source/feeds.conf
cat $compile/custom/etc/openwrt-banner > $compile/source/package/base-files/files/etc/banner
mkdir -p $compile/source/files/etc/config
cp -R $compile/custom/etc/config/firewall $compile/source/files/etc/config/
cp -R $compile/custom/etc/config/olsrd2 $compile/source/files/etc/config/
cp -R $compile/custom/etc/config/openvpn $compile/source/files/etc/config/
cp -R $compile/custom/etc/config/openwisp $compile/source/files/etc/config/

if [ $VERSION = "BASE" ]; then
cp $compile/custom/etc/uci-defaults/* $compile/source/package/base-files/files/etc/uci-defaults/
fi

if [ $VERSION = "HOTSPOT" ]; then
cp $compile/custom/hotspot/uci-defaults/* $compile/source/package/base-files/files/etc/uci-defaults/
fi

if [ $VERSION = "HOTSPOT" ]; then
	cp -R $compile/custom/hotspot/config/nodogsplash $compile/source/files/etc/config/
        cp -R $compile/custom/hotspot/nodogsplash $compile/source/files/etc/
	cp -R $compile/custom/hotspot/scripts/ $compile/source/files/root/
fi

cd $compile/source
./scripts/feeds update -a && ./scripts/feeds install -a && \
cat $compile/$version > $compile/source/.config && \
make defconfig && make prereq && make V=s -j 4 >&1 | tee build.log | egrep -i '(warn|error)'  && \
mv $compile/source/bin/sunxi/*.img.gz $compile/Firmware/openwrt/$VERSION/ && \
mv $compile/source/.config $compile/Firmware/openwrt/$VERSION/config.txt && \
mv $compile/source/bin/sunxi/md5sums $compile/Firmware/openwrt/$VERSION/

if [ $VERSION = "HOTSPOT" ]; then
	rm -rf $compile/source
fi

echo "Scrivi la tua MicroSD con il comando"
echo ""
echo "gunzip -c Firmware/openwrt/$VERSION/openwrt-sunxi-Lamobo_R1-sdcard-vfat-ext4.img.gz |sudo dd of=/dev/sdX"
