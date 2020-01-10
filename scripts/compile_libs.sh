#/bin/sh

# This could be improved a lot.  We should at least split up the solvers and the AMPL user functions.
# At this point keeping it together is a bit easier to get the initial builds going.

# Make a directory to work in
export IDAES_SRC=`pwd`

# get stuff
wget https://ampl.com/netlib/ampl/solvers.tgz
tar -zxvf solvers.tgz

# Compile ASL, warnings about files existing seem to be okay

cd solvers
./configure
make
export ASL_BUILD=`pwd`/sys.`uname -m`.`uname -s`
cd $IDAES_SRC

# Compile IDAES function libraries

cd src
make
cd $IDAES_SRC

# Collect files

cd $IDAES_SRC
mkdir dist-lib
cd dist-lib
cp ../src/dist/*.so ./
cp ../license.txt ./

if [ "$(expr substr $(uname -s) 1 7)" == "MINGW64" ]; then
    # Winodws MinGW linked libraries
    cp /mingw64/bin/libstdc++-6.dll ./
    cp /mingw64/bin/libgcc_s_seh-1.dll ./
    cp /mingw64/bin/libwinpthread-1.dll ./
    cp /mingw64/bin/libgfortran-5.dll ./
    cp /mingw64/bin/libquadmath-0.dll ./
    cp /mingw64/bin/liblapack.dll ./
    cp /mingw64/bin/libblas.dll ./
fi

# here you pack files
tar -czvf idaes-lib.tar.gz *
