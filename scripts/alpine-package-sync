#!/bin/bash
set -e

OP_PACKAGE="$1"
APORTS_DIR="$HOME/aports"
HOLLYWOOD_DIR="$HOME/hollywood-packages/system/"
ALPINE_APKBUILD=""
HOLLYWOOD_APKBUILD="$HOLLYWOOD_DIR/$OP_PACKAGE/APKBUILD"

if ! [ -f $HOLLYWOOD_APKBUILD ]; then
    echo "Hollywood Package $OP_PACKAGE does not exist"
    exit
fi

# check aports 'main' for package
if [ -f "$APORTS_DIR/main/$OP_PACKAGE/APKBUILD" ]; then
    ALPINE_APKBUILD="$APORTS_DIR/main/$OP_PACKAGE/APKBUILD"
fi

# check aports 'testing' for package
if [ -f "$APORTS_DIR/testing/$OP_PACKAGE/APKBUILD" ]; then
    ALPINE_APKBUILD="$APORTS_DIR/testing/$OP_PACKAGE/APKBUILD"
fi

# check aports 'community' for package
if [ -f "$APORTS_DIR/community/$OP_PACKAGE/APKBUILD" ]; then
    ALPINE_APKBUILD="$APORTS_DIR/community/$OP_PACKAGE/APKBUILD"
fi

if [ "$ALPINE_APKBUILD" == "" ]; then
    echo "Could not find Alpine APKBUILD for $OP_PACKAGE"
    exit
fi

HW_VER=`grep pkgver= $HOLLYWOOD_APKBUILD | head -n1 | cut -d'=' -f2`
AL_VER=`grep pkgver= $ALPINE_APKBUILD | head -n1 | cut -d'=' -f2`

if [ "$HW_VER" == "$AL_VER" ]; then
    echo "$OP_PACKAGE Hollywood/Alpine version match: $HW_VER"
    exit
fi

# sort for the lowest version
LOWVER=`echo -e "$HW_VER\n$AL_VER" | sort -V | head -n1`
if ! [  "$LOWVER" = "$HW_VER" ]; then
    echo "$OP_PACKAGE newer than Alpine (OK) $HW_VER Alpine: $AL_VER"
    exit
fi

echo "$OP_PACKAGE out of date: Hollywood: $HW_VER Alpine: $AL_VER"

ALPINE_SOURCES=`grep -e "^source=\".*" $ALPINE_APKBUILD | cut -d'"' -f2`
HW_SOURCES=`grep -e "^source=\".*" $HOLLYWOOD_APKBUILD | cut -d'"' -f2`

# see if our source URL is the same
# Since we use variables in URLs for $pkgver and $pkgname we should match here.
# If we don't it warrants a manual intervention
if ! [ "$ALPINE_SOURCES" == "$HW_SOURCES" ]; then
    echo "First source= link does not match\nAlpine: $ALPINE_SOURCES\nHollywood:$HW_SOURCES"
    echo "Correct this and try this tool again."
    exit
fi

echo "We have matching source URL... proceeding ($ALPINE_SOURCES)"

# source the alpine APKBUILD to get variables
. $ALPINE_APKBUILD
AL_SHASUMS="$sha512sums"
AL_SUM=`echo $AL_SHASUMS | cut -d' ' -f1`
AL_NAME=`echo $AL_SHASUMS | cut -d' ' -f2`

# Get our alpine APKBUILD sources, filter some things we know we don't need
AL_SRCS=($source)
AL_FILTER_SRC=()
for i in "${AL_SRCS[@]}"
do
    if [[ $i == *".initd" ]]; then continue; fi
    if [[ $i == *".confd" ]]; then continue; fi    
    if [[ $i == *"musl"* ]]; then continue; fi    

    AL_FILTER_SRC+=($i)
done
AL_SRC_COUNT="${#AL_FILTER_SRC[@]}"

# source the hollywood APKBUILD to get variables
. $HOLLYWOOD_APKBUILD
HW_SHASUMS="$sha512sums"
HW_SUM=`echo $HW_SHASUMS | cut -d' ' -f1`
HW_NAME=`echo $HW_SHASUMS | cut -d' ' -f2`
# Get our alpine APKBUILD sources, filter some things we know we don't need
HW_SRCS=($source)
HW_FILTER_SRC=()
for i in "${HW_SRCS[@]}"
do
    if [[ $i == *".service" ]]; then continue; fi
    if [[ $i == *"musl"* ]]; then continue; fi    

    HW_FILTER_SRC+=($i)
done
HW_SRC_COUNT="${#HW_FILTER_SRC[@]}"

# Check to see if our counts match
if [ $AL_SRC_COUNT != $HW_SRC_COUNT ]; then
    echo "Mismatch in source count (Hollywood: $HW_SRC_COUNT Alpine: $AL_SRC_COUNT)"
    echo ""
    echo "Alpine Sources (filtered)"
    for i in "${AL_FILTER_SRC[@]}"
    do
        echo $i
    done
    echo ""
    echo "Hollywood Sources (filtered)"
    for i in "${HW_FILTER_SRC[@]}"
    do
        echo $i
    done
    echo ""
    read -p "Do you still wish to continue? (y/n) " -n 1 -r
    if ! [[ $REPLY =~ ^[Yy]$ ]]
    then
        exit
    fi
    echo ""
fi

# update pkgver
sed -i'' -e "s/pkgver\=$HW_VER/pkgver\=$AL_VER/g" $HOLLYWOOD_APKBUILD
# reset pkgrel
sed -i'' -e "s/pkgrel\=.*/pkgrel\=0/g" $HOLLYWOOD_APKBUILD

# update main package sha512sum
sed -i'' -e "s/${HW_SUM}/${AL_SUM}/g" $HOLLYWOOD_APKBUILD
# update main package name
sed -i'' -e "s/$HW_NAME/$AL_NAME/g" $HOLLYWOOD_APKBUILD

# show a diff
CURPWD="$pwd"
cd $HOLLYWOOD_DIR/$OP_PACKAGE/
git diff APKBUILD
cd $CURPWD

if [ -f "$HOLLYWOOD_APKBUILD-e" ]; then
    rm "$HOLLYWOOD_APKBUILD-e"
fi

COMMITMSG="$OP_PACKAGE: update package to $AL_VER"
echo $COMMITMSG
read -p "Do you want to commit this? " -n 1 -r
if ! [[ $REPLY =~ ^[Yy]$ ]]
then
    echo ""
    echo "Exiting"
    exit
fi
echo ""

CURPWD="$pwd"
cd $HOLLYWOOD_DIR/$OP_PACKAGE/
git add APKBUILD
git commit -m "$COMMITMSG"
git push
cd $CURPWD
