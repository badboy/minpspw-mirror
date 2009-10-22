#!/bin/bash
. ../util/util.sh

LIBNAME=SDL
VERSION=1.2.9

svnGetPS2DEV $LIBNAME

cd $LIBNAME
sh autogen.sh
LDFLAGS="-L$(psp-config --pspsdk-path)/lib" LIBS="-lc -lpspuser" ./configure --host psp --prefix=$(pwd)/../target/psp --enable-pspirkeyb

make || { echo "Error building $LIBNAME"; exit 1; }

make install || { echo "Error installing $LIBNAME"; exit 1; }
mkdir -p ../target ../target/doc
mv ../target/psp/share/man ../target
rm -fR ../target/psp/share
cp README.PSP ../target/doc/$LIBNAME.txt

cd ..

mkdir -p target/bin

if [ "$OS" == "SunOS" ]; then
	gcc-4.3.2 -s -o target/bin/sdl-config -DPREFIX=\"\" -DEXEC_PREFIX=\"\" -DVERSION=\"$VERSION\" ../sdl-config.c || exit 1
else
	gcc -s -o target/bin/sdl-config -DPREFIX=\"\" -DEXEC_PREFIX=\"\" -DVERSION=\"$VERSION\" ../sdl-config.c || exit 1
fi

makeInstaller $LIBNAME $VERSION pspgl 2264 pspirkeyb 0.0.4

echo "Done!"

