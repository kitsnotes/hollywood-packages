#!/bin/bash

APORTS_DIR="$HOME/aports"
HOLLYWOOD_DIR="$HOME/hollywood-packages/system/"
ALPINE_APKBUILD=""

find $HOLLYWOOD_DIR -maxdepth 1 -type d | while read dir; do
    PKGNAME="$(basename "$dir")"
    ALPINE_APKBUILD=""
    HOLLYWOOD_APKBUILD="$HOLLYWOOD_DIR/$PKGNAME/APKBUILD"
    # check aports 'main' for package
    if [ -f "$APORTS_DIR/main/$PKGNAME/APKBUILD" ]; then
        ALPINE_APKBUILD="$APORTS_DIR/main/$PKGNAME/APKBUILD"
    fi

    # check aports 'testing' for package
    if [ -f "$APORTS_DIR/testing/$PKGNAME/APKBUILD" ]; then
        ALPINE_APKBUILD="$APORTS_DIR/testing/$PKGNAME/APKBUILD"
    fi

    # check aports 'community' for package
    if [ -f "$APORTS_DIR/community/$PKGNAME/APKBUILD" ]; then
        ALPINE_APKBUILD="$APORTS_DIR/community/$PKGNAME/APKBUILD"
    fi

    if [ "$ALPINE_APKBUILD" == "" ]; then
        continue
    fi

    HW_VER=`grep pkgver= $HOLLYWOOD_APKBUILD | head -n1 | cut -d'=' -f2`
    AL_VER=`grep pkgver= $ALPINE_APKBUILD | head -n1 | cut -d'=' -f2`

    if [ "$HW_VER" == "$AL_VER" ]; then
        continue
    fi

    LOWVER=`echo -e "$HW_VER\n$AL_VER" | sort -V | head -n1`
    if ! [  "$LOWVER" = "$HW_VER" ]; then
        echo "$PKGNAME newer than Alpine (OK) $HW_VER Alpine: $AL_VER"
        continue
    fi

    echo "$PKGNAME out of date: Hollywood: $HW_VER Alpine: $AL_VER"

done
