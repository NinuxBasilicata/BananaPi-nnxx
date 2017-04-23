#/bin/bash -x
compile=`pwd`

echo "Quale versione vuoi compilare?"
echo "Scrivi BASE oppure HOTSPOT"
read VERSION

if [ $VERSION = "BASE" ]; then
    version='custom/lede-config-base'
fi
if [ $VERSION = "HOTSPOT" ]; then
    version='custom/lede-config-nodogsplash'
fi


if [ -d source ]; then
	cd source && git pull
fi
if [ ! -d source ]; then
        git clone https://github.com/lede-project/source.git
fi
if [ -d $compile/Firmware/lede/$VERSION ]; then
        rm -rf $compile/Firmware/lede/$VERSION
fi
if [ ! -d $compile/Firmware/lede/$VERSION ]; then
        mkdir -p $compile/Firmware/lede/$VERSION
fi

cat $compile/custom/lede-feeds.conf > $compile/source/feeds.conf
cat $compile/custom/etc/lede-banner > $compile/source/package/base-files/files/etc/banner
mkdir -p $compile/source/files/etc/config
cp -R $compile/custom/etc/config/* $compile/source/files/etc/config/
cp $compile/custom/etc/uci-defaults/* $compile/source/package/base-files/files/etc/uci-defaults/
cd $compile/source
./scripts/feeds update -a && ./scripts/feeds install -a && \
cat $compile/$version > $compile/source/.config && \
make defconfig && make prereq && make V=s -j 4 >&1 | tee build.log | egrep -i '(warn|error)'  && \
mv $compile/source/bin/targets/sunxi/generic/*.img.gz $compile/Firmware/lede/$VERSION/ && \
mv $compile/source/bin/targets/sunxi/generic/config.seed $compile/Firmware/lede/$VERSION/

# make clean && make dirclean
