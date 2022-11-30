export TMPDIR="/scratch/$USER/tmp"

TMP="$(mktemp -d)"

BASEDIR=$(cd .. && pwd)

version=2.5.1
fullversion=$version-py39
shortversion=2_5 # needed for download link

prefix=$BASEDIR/install/ViennaRNA-$fullversion
moduledir=$BASEDIR/modules/ViennaRNA
pyver=3.9
module use $BASEDIR/modules
module purge
# Vienna is not happy with gcc 4.9.
# I need to use a more recent gcc.
# I am loading intel/2021.2 since this is the same compiler I am using
# for GROMACS and PLUMED, to avoid conflicts.
# Vienna will actually use gcc, which here is gcc 8
module load intel/2021.2
module load python/$pyver

# install
true &&
cd $TMP &&
curl -LO https://www.tbi.univie.ac.at/RNA/download/sourcecode/${shortversion}_x/ViennaRNA-$version.tar.gz &&
tar xzf ViennaRNA-$version.tar.gz &&
cd ViennaRNA-$version &&
./configure --prefix=$prefix --without-perl --without-python2 &&
make -j 12 &&
make install &&
chmod -R a-w $prefix &&
chmod -R a+rX $prefix &&
rm -fr $TMP

mkdir -p $moduledir
cat > $moduledir/$fullversion << EOF
#%Module1.0##############################################

conflict ViennaRNA

prepend-path  PATH             $prefix/bin
prepend-path  CPATH            $prefix/include
prepend-path  INCLUDE          $prefix/include
prepend-path  MANPATH          $prefix/share/man
prepend-path  LIBRARY_PATH     $prefix/lib
prepend-path  LD_LIBRARY_PATH  $prefix/lib
prepend-path  PYTHONPATH       $prefix/lib/python$pyver/site-packages
EOF

