DIR=$(dirname "$(pwd)")

# Set the system directory
DIR=$(dirname "$(pwd)")/system

# Check if the directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory '$DIR' does not exist."
  exit 1
fi

# Loop through each subdirectory
for subdir in "$DIR"/py3-*/; do
  if [ -f "$subdir/APKBUILD" ];  then
     cd $subdir
     current_pkgrel=$(grep -oE 'pkgrel=[0-9]+' APKBUILD | cut -d'=' -f2)
     new_pkgrel=$((current_pkgrel + 1))
#     sed -i "s/pkgrel=$current_pkgrel/pkgrel=$new_pkgrel/" APKBUILD
#     echo "pkgrel incremented from $current_pkgrel to $new_pkgrel in $subdir/APKBUILD."
     abuild -r
  fi
done
cd ~
