#!/bin/bash

# Check if the argument (package name) is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <package name>"
    exit 1
fi

# Define the package name from the argument
pkgname="$1"

# Search for the corresponding APKBUILD file in ~/hollywood-packages/system/
hw_apkbuild="/home/buildbot/hollywood-packages/system/$pkgname/APKBUILD"

# Check if a matching APKBUILD was found
if [ -z "$hw_apkbuild" ]; then
    echo "Error: No matching APKBUILD found in ~/hollywood-packages/system/ for package $pkgname"
    exit 1
fi

hw_pkgver=$(awk -F'=' '/pkgver=/ {gsub(/[[:space:]]/, "", $2); print $2}' "$hw_apkbuild")

# Find our corresponding alpine package
alpine_apkbuild=$(find ~/aports -type d -name "$pkgname" -exec test -e "{}/APKBUILD" \; -print)
alpine_pkgver=$(awk -F'=' '/pkgver=/ {gsub(/[[:space:]]/, "", $2); print $2}' "$alpine_apkbuild/APKBUILD")
echo "Alpine: $alpine_pkgver Hollywood: $hw_pkgver"
