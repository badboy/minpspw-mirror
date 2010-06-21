#!/bin/bash
set -e
. ../util/util.sh

LIBNAME=cal3D
VERSION=0.10.0

svnGet build svn://svn.ps2dev.org/psp/trunk $LIBNAME

cd build/$LIBNAME
rm -Rf autom4te.cache
mkdir -p ../build
cd ../build

LDFLAGS="-L$(psp-config --pspsdk-path)/lib" LIBS="-lstdc++ -lpsplibc -lpspuser" ../$LIBNAME/configure --host=psp --disable-shared --prefix=$(pwd)/../target/psp

LDFLAGS="-L$(psp-config --pspsdk-path)/lib" LIBS="-lstdc++ -lpsplibc -lpspuser" make
make install 

mkdir -p ../target/doc
cp ../$LIBNAME/README ../target/doc/$LIBNAME.txt

cd ../..

makeInstaller $LIBNAME $VERSION

echo "Done!"
