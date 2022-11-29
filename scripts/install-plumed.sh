export TMPDIR="/scratch/$USER/tmp"

TMP="$(mktemp -d)"

BASEDIR=$(cd .. && pwd)

version=2.8.1
shortversion=2.8

prefix=$BASEDIR/install/plumed-$version
moduledir=$BASEDIR/modules/plumed/$shortversion
module purge
module load intel/2021.2
module load openmpi3/3.1.4

# install
true &&
cd $TMP &&
wget https://github.com/plumed/plumed2/releases/download/v$version/plumed-$version.tgz &&
tar xzf plumed-$version.tgz &&
cd plumed-$version &&
./configure --prefix=$prefix --enable-rpath --enable-modules=all
make -j 12 &&
make install &&
chmod -R a-w $prefix &&
chmod -R a+rX $prefix &&
rm -fr $TMP &&
mkdir -p $moduledir &&
awk '
  {print;}
  /Manually add/{
    print("depends-on intel/2021.2")
    # print("openmpi3/3.1.4") # not needed due to rpath
    print("setenv OMPI_MCA_mca_base_component_show_load_errors 0")
  } 
' < $prefix/lib/plumed/modulefile > $moduledir/$version


