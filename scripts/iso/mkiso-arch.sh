#!/bin/bash
set -e

BUILD_ID="$1"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
OUT_DIR="$HOME/iso-output"
ELEVATE="doas"

if [ -z "$1" ]; then
	echo "Please run this script with a build ID (ie: 67)"
	exit 1
fi

if ! [[ "$1" =~ ^-?[0-9]+$ ]]; then
    echo "Error: The argument must be an integer"
    exit 1
fi

mkdir -pv $OUT_DIR || true

# TODO: fix horizon not accepting -f

# Create our ARM64 based iso
if [ `uname -m` == "aarch64" ]; then
	$ELEVATE ln -s "$SCRIPT_DIR/arm64-iso.hs" /etc/hollywood.hs
	$ELEVATE hscript-image \
		-t iso \
		-o "$OUT_DIR/HWARM64-B${BUILD_ID}.ISO" \
		-f "$SCRIPT_DIR/arm64-iso.hs"
	$ELEVATE unlink /etc/hollywood.hs
fi

# Create our AMD64 based ISO
if [ `uname -m` == "x86_64" ]; then
	$ELEVATE ln -s "$SCRIPT_DIR/amd64-iso.hs" /etc/hollywood.hs
	$ELEVATE hscript-image \
	        -t iso \
	        -o "$OUT_DIR/HWAMD64-B${BUILD_ID}.ISO" \
	        -f "$SCRIPT_DIR/amd64-iso.hs"
	$ELEVATE unlink /etc/hollywood.hs
fi
