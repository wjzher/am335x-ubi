#!/bin/sh

#ubiattach /dev/ubi_ctrl -m 9
#[  102.368212] ubi0: attaching mtd9
#[  103.397717] ubi0: scanning is finished
#[  103.421590] ubi0: attached mtd9 (name "NAND.file-system", size 1009 MiB)
#[  103.428721] ubi0: PEB size: 524288 bytes (512 KiB), LEB size: 520192 bytes
#[  103.447082] ubi0: min./max. I/O unit sizes: 4096/4096, sub-page size 1024
#[  103.460875] ubi0: VID header offset: 1024 (aligned 1024), data offset: 4096
#[  103.469438] ubi0: good PEBs: 2019, bad PEBs: 0, corrupted PEBs: 0
#[  103.476530] ubi0: user volume: 0, internal volumes: 1, max. volumes count: 128
#[  103.484887] ubi0: max/mean erase counter: 0/0, WL threshold: 4096, image sequence number: 908387009
#[  103.494964] ubi0: available PEBs: 1975, total reserved PEBs: 44, PEBs reserved for bad PEB handling: 40
#[  103.505495] ubi0: background thread "ubi_bgt0d" started, PID 1220
#UBI device number 0, total 2019 LEBs (1050267648 bytes, 1001.6 MiB), 
#available 1975 LEBs (1027379200 bytes, 979.8 MiB), LEB size 520192 bytes (508.0 KiB)

PAGESIZE=4096
LEBSIZE=520192	# 508K
LEBCOUNT=1974	# 979.8M
SUBPAGE=1024	# sub page size
PEBSIZE=512KiB
UBISIZE=970MiB

ROOTFSPATH=./rootfs-ubuntu-16.04-nkty-4.4.107-r21

echo "create ubi image ..."
echo "del ubifs-1g.img and ubi-1g.img"

rm -f ubifs-1g.img ubi-1g.img

mkfs_cmd="mkfs.ubifs -F -q -r ${ROOTFSPATH} -m ${PAGESIZE} -e ${LEBSIZE} -c ${LEBCOUNT} -o ubifs-1g.img"
echo ${mkfs_cmd}
eval sudo ${mkfs_cmd}

#rm -f ubinize.cfg

echo "[ubifs]" > ubinize.cfg
echo "mode=ubi" >> ubinize.cfg
echo "image=ubifs-1g.img" >> ubinize.cfg
echo "vol_id=0" >> ubinize.cfg
echo "vol_size=${UBISIZE}" >> ubinize.cfg
echo "vol_type=dynamic" >> ubinize.cfg
echo "vol_name=rootfs" >> ubinize.cfg
echo "vol_flags=autoresize" >> ubinize.cfg

ubinize_cmd="ubinize -o ubi-1g.img -m ${PAGESIZE} -p ${PEBSIZE} -s ${SUBPAGE} ubinize.cfg -v"
echo ${ubinize_cmd}
eval ${ubinize_cmd}

#ubinize -o ubi.img -m ${PAGESIZE} -p ${PEBSIZE} -s ${SUBPAGE} ubinize.cfg -v
#ubinize -o ubi.img -m ${PAGESIZE} -s ${SUBPAGE} -p ${PEBSIZE} ubinize.cfg -v
# -v

echo "done"

