DIR=$(dirname "$(pwd)")

# Set the system directory
DIR=$(dirname "$(pwd)")/system

# Check if the directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory '$DIR' does not exist."
  exit 1
fi

PKGS="$1"
# Loop through each subdirectory
for pkg in $PKGS; do
  if [ -f "$DIR/$pkg/APKBUILD" ]; then
    cd "$DIR/$pkg" && abuild -r
  fi
done
cd ~
