# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: target/share/firmware/build.sh
# Copyright (C) 2012 - 2013 BoneOS build platform (http://www.teebx.com/)
# Copyright (C) 2004 - 2011 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---
#
#Description: initramfs

. $base/misc/target/functions.in

set -e

echo "Preparing initramfs image from build result ..."

rm -rf $initramfs_loc{,.igz}
mkdir -p $initramfs_loc
pushd $initramfs_loc

find $build_root -printf "%P\n" | sed '

# stuff we never need

/^TOOLCHAIN/							d;
/^offload/								d;

/\.a$/									d;
/\.o$/									d;
/\.old$/								d;
/\.svn/									d;
/\.po/									d;

 /^boot/								d;
/\/doc/									d;
/\/games/								d;
/\/include/								d;
/\/opt/									d;
/\/src/									d;
  /etc\/conf/							d;
  /etc\/cron.d/							d;
  /etc\/cron.daily/						d;
  /etc\/dahdi\/system.conf/				d;
  /etc\/hotplug/						d;
  /etc\/hotplug.d/						d;
  /etc\/init.d/							d;
  /etc\/opt/							d;
  /etc\/postinstall.d/					d;
  /etc\/profile.d/						d;
  /etc\/rc.d\//							d;
  /etc\/skel/							d;
  /etc\/stone.d/						d;
  /lib\/modules/						d;
  /var\/adm/							d;
# new bits to move usr/* out of the initramfs and into /offload
  /usr/									d;

' > tar.input

copy_with_list_from_file $build_root . $PWD/tar.input
rm tar.input

echo "Preparing initramfs image from target defined files ..."
copy_from_source $base/target/$target/rootfs .
copy_from_source $base/target/share/initramfs/rootfs .

echo "Storing a default appliance configuration file in initramfs..."
mkdir conf.default
if [ -f "$base/target/$target/config.xml" ]; then
	echo "  -> Copying target specific configuration file."
	cp $base/target/$target/config.xml conf.default/
else
	if [ -f "$base/target/share/config.xml" ]; then
		echo "  -> Copying shared target configuration file."
		cp $base/target/share/config.xml conf.default/
	else
		echo "  -> Default configuration file not found, exiting!"
		exit 1
	fi
fi

echo "Setup some symlinks ..."
ln -s /offload/kernel-modules lib/modules

echo "Stamping build ..."
echo $config > etc/version
echo `date +%s` > etc/version.buildtime

echo "Creating links for identical files ..."
link_identical_files

echo "Setting permissions ..."
chmod 755 init
chmod 755 bin/*
chmod 755 sbin/*
chmod 755 etc/rc*
if [ -f etc/pubkey.pem ];
then
	chmod 644 etc/pubkey.pem
fi
if [ -d etc/inc ];
then
	chmod 644 etc/inc/*
fi

echo "Cleaning away stray files ..."
find ./ -type f -name "._*" -print -delete

#remove openssh build files
rm -rf $initramfs_loc/opt/bin
rm -rf $initramfs_loc/opt/etc
rm -rf $initramfs_loc/opt/sbin

echo "Creating initramfs image..."
find . | cpio -H newc -o | gzip > "$build_toolchain/initramfs.igz"
echo "  -> Done."

echo "The image is located at $build_toolchain/initramfs.igz"

if [ "$image_type" == "livecd" ] ; then
	mv etc/rc.mountoffload etc/rc.mountoffload.save
	mv etc/rc.livecd.mountoffload etc/rc.mountoffload

	echo "Creating live CD initramfs image..."
	find . | cpio -H newc -o | gzip > "$build_toolchain/initramfs.livecd.igz"
	echo "  -> Done."

	mv etc/rc.mountoffload etc/rc.livecd.mountoffload
	mv etc/rc.mountoffload.save etc/rc.mountoffload
fi

popd
