#!/bin/bash
ALPINE_PKGDIR="/home/buildbot/aports"

HW_PKGDIR=$(dirname "$(pwd)")

# Set the system directory
HW_PKGDIR=$(dirname "$(pwd)")/system

# Check if the directory exists
if [ ! -d "$HW_PKGDIR" ]; then
  echo "Directory '$HW_PKGDIR' does not exist."
  exit 1
fi

function alpine_check()
{
pkgname=$1
# Search for the corresponding APKBUILD file in ~/hollywood-packages/system/
hw_apkbuild="$HW_PKGDIR/$pkgname/APKBUILD"

# Check if a matching APKBUILD was found
if ! [ -f "$hw_apkbuild" ]; then
    return
fi

hw_pkgver=$(awk -F'=' '/pkgver=/ {gsub(/[[:space:]]/, "", $2); print $2}' "$hw_apkbuild")
# Find our corresponding alpine package
alpine_apkbuild=$(find $ALPINE_PKGDIR -type d -name "$pkgname" -exec test -e "{}/APKBUILD" \; -print)
if [ -z "$alpine_apkbuild" ]; then
    return
fi

alpine_pkgver=$(awk -F'=' '/pkgver=/ {gsub(/[[:space:]]/, "", $2); print $2}' "$alpine_apkbuild/APKBUILD")
if [ "$alpine_pkgver" != "$hw_pkgver" ]; then
    echo "$pkgname: Alpine: $alpine_pkgver Hollywood: $hw_pkgver"
fi
}

find $HW_PKGDIR -type d -printf '%f\n' | while read -r line; do
    # Call the arrgh function with the current line as an argument
    alpine_check "$line"
done
