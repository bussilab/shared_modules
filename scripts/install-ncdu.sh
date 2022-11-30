export TMPDIR="/scratch/$USER/tmp"

TMP="$(mktemp -d)"

BASEDIR=$(cd .. && pwd)

version=1.17

fullversion=$version
prefix=$BASEDIR/install/ncdu-$version
moduledir=$BASEDIR/modules/ncdu
module use $BASEDIR/modules
module purge

# install
true &&
cd $TMP &&
curl -LO https://dev.yorhel.nl/download/ncdu-${version}.tar.gz &&
tar xzf ncdu-$version.tar.gz &&
cd ncdu-$version &&
./configure --prefix=$prefix
make -j 12 &&
make install &&
chmod -R a-w $prefix &&
chmod -R a+rX $prefix &&
rm -fr $TMP

mkdir -p $moduledir
cat > $moduledir/$version << EOF
#%Module1.0##############################################

conflict ncdu

prepend-path  MANPATH          $prefix/share/man
prepend-path  PATH             $prefix/bin
EOF

