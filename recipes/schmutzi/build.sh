#!/bin/bash
export CPP_INCLUDE_PATH=${PREFIX}/include
export CXX_INCLUDE_PATH=${PREFIX}/include
export CPLUS_INCLUDE_PATH=${PREFIX}/include
export LIBRARY_PATH=${PREFIX}/lib

#Adust path to copy executables too with prefix
sed -i.bak "s#usr/bin/#${PREFIX}/bin#g" Makefile
sed -i.bak "s#usr/share/#${PREFIX}/share#g" Makefile

# Fix shebangs
sed -i.bak "s:usr/bin/perl:usr/bin/env perl:" src/*.pl

#Create dir for shared reference files
mkdir -p $PREFIX/share

# schmutzi uses non-standard bamtools functions that aren't part of the normal library
cd lib
rmdir bamtools
git clone https://github.com/pezmaster31/bamtools
mkdir bamtools/build
cd bamtools/build
cmake ..
make
cd ../..

# Build libgab
rmdir libgab
git clone https://github.com/grenaud/libgab
cd libgab
make BAMTOOLSINC=${PREFIX}/include/bamtools BAMTOOLSLIB=${PREFIX}/lib
#Copy libgab header files to include directories (?)
cp -fv *.h ${PREFIX}/include/
cp -fv *.o ${PREFIX}/lib/

cd ../..



make install
