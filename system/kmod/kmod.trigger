#!/bin/sh

for i in "$@"; do
	if [ -d "$i" ]; then
		/usr/sbin/depmod ${i#/lib/modules/}
		fi
done

