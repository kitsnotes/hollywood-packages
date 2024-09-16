#!/bin/sh

if grep -q '^disable_kernel_update_trigger=1' /etc/bootloader.conf 2>/dev/null; then
	exit 0
fi

exec /usr/sbin/bootloader-update-kernels

