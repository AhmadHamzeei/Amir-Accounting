#!/bin/bash
## This script builds DEB package on a debian-based distribution
## Thanks to Saeed Rasooli <saeed.gnu@gmail.com>

pkgName=amir
version=0.1

function getDirTotalSize(){
    du -ks "$1" | python2 -c "import sys;print(raw_input().split('\t')[0])"
}

if [ "$UID" != "0" ] ; then
  echo "Run this script as root"
  exit 1
fi

myPath="$0"
if [ "${myPath:0:2}" == "./" ] ; then
    myPath=$PWD${myPath:1}
elif [ "${myPath:0:1}" != "/" ] ; then
    myPath=$PWD/$myPath
fi

sourceDir="`dirname \"$myPath\"`"

tmpDir=/tmp/amir-install-deb
mkdir -p "$tmpDir/DEBIAN"
mkdir -p "$tmpDir/usr/share/amir"
mkdir -p "$tmpDir/usr/share/applications"
mkdir -p "$tmpDir/usr/share/doc/amir"
mkdir -p "$tmpDir/usr/bin"

cp -r "$sourceDir/amir" "$tmpDir/usr/share/amir/amir"
cp -r "$sourceDir/bin" "$tmpDir/usr/share/amir/bin"
cp -r "$sourceDir/data" "$tmpDir/usr/share/amir/data"
mv "$tmpDir/usr/share/amir/data/amir.desktop" "$tmpDir/usr/share/applications/amir.desktop"
mv "$tmpDir/usr/share/amir/data/amir" "$tmpDir/usr/bin/amir"
mv "$tmpDir/usr/share/amir/data/icons" "$tmpDir/usr/share/icons"
cp "$sourceDir/AUTHORS" "$tmpDir/usr/share/doc/amir/AUTHORS"
cp "$sourceDir/CHANGELOG" "$tmpDir/usr/share/doc/amir/CHANGELOG"
cp "$sourceDir/COPYING" "$tmpDir/usr/share/doc/amir/COPYING"
cp -r "$sourceDir/doc/html" "$tmpDir/usr/share/doc/amir/html"
cp -r "$sourceDir/po/locale" "$tmpDir/usr/share/locale"

chown -R root "$tmpDir"
installedSize=`getDirTotalSize "$tmpDir"`

depends=('python(>=2.6)' 'python(<<3.0)')
depends+=('python-gtk2(>=2.8)')
depends+=('python-migrate')
depends+=('python-tempita')
depends+=('python-cairo')
depends+=('python-gobject')
depends+=('python-sqlalchemy(>=0.6.0)')
depends+=('python-glade2')

depends_str=$(printf ", %s" "${depends[@]}") ; depends_str=${depends_str:2}

echo "Package: $pkgName
Version: $version
Architecture: all
Maintainer: Ahmad Hamzeei <ahmadhamzeei@gmail.com>
Installed-Size: $installedSize
Depends: $depends_str
Section: Utilities
Priority: optional
Homepage: http://www.freeamir.com/
Description: Amir accounting software
 Just another accounting software for persian
" > "$tmpDir/DEBIAN/control"

pkgFile=${pkgName}_${version}-1_all.deb
dpkg-deb -b "$tmpDir" "$pkgFile"

rm -Rf "$tmpDir"

