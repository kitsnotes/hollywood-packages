DIR="/home/buildbot/hollywood-packages/system"

# Check if the directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory '$DIR' does not exist."
  exit 1
fi

# Loop through each subdirectory
for subdir in "$DIR"/*/; do
  if [ -f "$subdir/APKBUILD" ]; then
    pkgname=`basename $subdir`
    echo "$pkgname dependencies: ABUILD: `find $DIR -name APKBUILD -type f -exec grep -Hie "depends=\".*$pkgname.*\"" {} \; | wc -l` APK Requires: `apk info -r $pkgname | wc -l` Required By: `apk info -R $pkgname | wc -l`"
  fi
done
