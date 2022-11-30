export TMPDIR="/scratch/$USER/tmp"

TMP="$(mktemp -d)"

BASEDIR=$(cd .. && pwd)

version=2020.7
shortversion=2020

fullversion=$version-cr-p-2.8.1
prefix=$BASEDIR/install/gromacs-$fullversion
moduledir=$BASEDIR/modules/gromacs/$shortversion
module use $BASEDIR/modules
module purge
module load cmake
module load intel/2021.2
module load openmpi3/3.1.4
module load cuda/10.1
module load plumed/2.8/2.8.1

# hack
CPATH=$CPATH:$MPI_DIR/include

# install
true &&
cd $TMP &&
curl -LO https://ftp.gromacs.org/gromacs/gromacs-$version.tar.gz &&
tar xzf gromacs-$version.tar.gz &&
cd gromacs-$version &&
bash <(curl -s https://raw.githubusercontent.com/bussilab/crescale-gromacs/readme/patch-v2020.6) &&
plumed-patch -p --runtime -e gromacs-2020.7 &&
mkdir build-sp &&
cd build-sp &&
cmake .. \
    -DCMAKE_C_COMPILER:FILEPATH=$(which mpicc) \
    -DCMAKE_CXX_COMPILER:FILEPATH=$(which mpic++) \
    -DCMAKE_INSTALL_PREFIX:STRING=$prefix \
    -DGMX_MPI=ON \
    -DCUDA_HOST_COMPILER:FILEPATH=$(which icc) \
    -DGMX_BUILD_OWN_FFTW=ON &&
make -j 12 &&
make install &&
cd ../ &&
mkdir build-dp &&
cd build-dp &&
cmake .. \
    -DCMAKE_C_COMPILER:FILEPATH=$(which mpicc) \
    -DCMAKE_CXX_COMPILER:FILEPATH=$(which mpic++) \
    -DCMAKE_INSTALL_PREFIX:STRING=$prefix \
    -DGMX_MPI=ON \
    -DGMX_BUILD_OWN_FFTW=ON \
    -DGMX_DOUBLE=ON &&
make -j 12 &&
make install &&
cd ../ &&
chmod -R a-w $prefix &&
chmod -R a+rX $prefix &&
rm -fr $TMP

mkdir -p $moduledir
cat > $moduledir/$version << EOF
#%Module1.0##############################################

conflict gromacs

setenv OMPI_MCA_mca_base_component_show_load_errors 0

depends-on intel/2021.2
depends-on openmpi3/3.1.4
depends-on cuda/10.1

prepend-path  LD_LIBRARY_PATH  $prefix/lib
prepend-path  LIBRARY_PATH     $prefix/lib
prepend-path  INCLUDE          $prefix/include
prepend-path  CPATH            $prefix/include
prepend-path  MANPATH          $prefix/share/man
prepend-path  PATH             $prefix/bin
prepend-path  GMXLIB           $prefix/share/gromacs/top/
EOF




