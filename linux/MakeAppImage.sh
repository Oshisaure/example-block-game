#!/usr/bin/env bash
# [2022/04/11] [06:16:44 (JST)]
# Dependancies: curl, AppImageKit

if ! [[ "$1" == *".love"* ]]; then
  echo "Invalid Input!"
  echo "Usage: ./MakeAppImage.sh [.love file]"
  exit 2
fi

FILE=$1 # Path to game file
NAME=$(basename -s .love $1) # File name without extension

# Clears the directory except for the script itself
find . ! -name '*.sh' -delete

# Pulls the latest generic official appimage
curl -LJO https://api.github.com/repos/love2d/love/releases/latest
LOVE_APPIMAGE_URL=($( \
  grep browser_download_url latest \
  | grep -i appimage \
  | cut -d '"' -f 4 \
))
curl -LJO "$LOVE_APPIMAGE_URL"
if ! [ -f *.AppImage ]; then echo "Failed to get LOVE appimage!"; exit 2; fi

# Inserts the .love file and customises the AppImage
chmod +x *.AppImage
./*.AppImage --appimage-extract
cat squashfs-root/bin/love $FILE > squashfs-root/bin/$NAME
chmod +x squashfs-root/bin/$NAME
cp ../assets/logo.svg squashfs-root/
ln -sf logo.svg squashfs-root/.DirIcon
sed -i 's/\(Name=\)\(.*\)/\1Example Block Game/' squashfs-root/love.desktop
sed -i 's/\(Comment=\)\(.*\)/\1Open source simple block game/' squashfs-root/love.desktop
sed -i "s/\(Exec=\)\(.*\)/\1$NAME %f/" squashfs-root/love.desktop
sed -i "s/\(Categories=\)\(.*\)/\1Game;/" squashfs-root/love.desktop
sed -i "s/\(Icon=\)\(.*\)/\1logo/" squashfs-root/love.desktop
rm squashfs-root/love.svg
rm squashfs-root/*.txt

# Makes the thing
appimagetool squashfs-root $NAME.AppImage
