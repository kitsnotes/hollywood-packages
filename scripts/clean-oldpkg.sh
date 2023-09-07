DIR=$(dirname "$(pwd)")

# Set the system directory
DIR=$(dirname "$(pwd)")/system

# Check if the directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory '$DIR' does not exist."
  exit 1
fi

# Loop through each subdirectory
for subdir in "$DIR"/*/; do
  if [ -f "$subdir/APKBUILD" ]; then
    cd $subdir && abuild cleanoldpkg
  fi
done
cd ~
