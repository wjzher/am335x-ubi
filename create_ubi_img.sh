#!/bin/sh

PAGESIZE=2048
LEBSIZE=129024	# 126K
LEBCOUNT=1918	# 236M
SUBPAGE=512	# sub page size
PEBSIZE=128KiB
UBISIZE=230MiB

ROOTFSPATH=./rootfs-nkty-4.4.107-r21

echo "create ubi image ..."
echo "del ubifs.img and ubi.img"

rm -f ubifs.img ubi.img

mkfs_cmd="mkfs.ubifs -F -q -r ${ROOTFSPATH} -m ${PAGESIZE} -e ${LEBSIZE} -c ${LEBCOUNT} -o ubifs.img"
echo ${mkfs_cmd}
eval sudo ${mkfs_cmd}

#rm -f ubinize.cfg

echo "[ubifs]" > ubinize.cfg
echo "mode=ubi" >> ubinize.cfg
echo "image=ubifs.img" >> ubinize.cfg
echo "vol_id=0" >> ubinize.cfg
echo "vol_size=${UBISIZE}" >> ubinize.cfg
echo "vol_type=dynamic" >> ubinize.cfg
echo "vol_name=rootfs" >> ubinize.cfg
echo "vol_flags=autoresize" >> ubinize.cfg

ubinize_cmd="ubinize -o ubi.img -m ${PAGESIZE} -p ${PEBSIZE} -s ${SUBPAGE} ubinize.cfg -v"
echo ${ubinize_cmd}
eval ${ubinize_cmd}

#ubinize -o ubi.img -m ${PAGESIZE} -p ${PEBSIZE} -s ${SUBPAGE} ubinize.cfg -v
#ubinize -o ubi.img -m ${PAGESIZE} -s ${SUBPAGE} -p ${PEBSIZE} ubinize.cfg -v
# -v

echo "done"

