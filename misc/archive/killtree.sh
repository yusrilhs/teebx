#!/bin/sh
#
# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: misc/archive/killtree.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# Copyright (C) 1998 - 2003 ROCK Linux Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

main() {
	for y in `cut -f1,4 -d' ' /proc/*/stat | grep " $1\$" | cut -f1 -d' '`
	do main $y "$2  " ; done
	out="$( kill -$signal $1 2>&1 )"
	if [ "$out" ] ; then echo "$2$out"
	else echo "$2""Killing PID $1." ; fi
}

signal=$1
shift

if [ $# = 0 ] ; then
	echo "Usage: $0 <signal> <pid> [ <pid> [ ... ] ]"
	exit 1
else
	for x ; do
		echo
		echo "Killing tree $x upside-down:"
		main $x ""
	done
	echo
fi

exit 0
