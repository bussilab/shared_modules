export TMPDIR="/scratch/$USER/tmp"

TMP="$(mktemp -d)"

BASEDIR=$(cd .. && pwd)

version=3.2.1

fullversion=$version
prefix=$BASEDIR/install/htop-$version
moduledir=$BASEDIR/modules/htop
module use $BASEDIR/modules
module purge

# install
true &&
cd $TMP &&
curl -LO https://github.com/htop-dev/htop/releases/download/${version}/htop-${version}.tar.xz &&
tar xJf htop-$version.tar.xz &&
cd htop-$version &&
./configure --prefix=$prefix
make -j 12 &&
make install &&
chmod -R a-w $prefix &&
chmod -R a+rX $prefix &&
rm -fr $TMP

mkdir -p $moduledir
cat > $moduledir/$version << EOF
#%Module1.0##############################################

conflict htop

prepend-path  MANPATH          $prefix/share/man
prepend-path  PATH             $prefix/bin
EOF

