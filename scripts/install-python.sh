umask 022
export TMPDIR="/scratch/$USER/tmp"

module purge

TMP="$(mktemp -d)"

BASEDIR=$(cd .. && pwd)

versions="3.9.14 3.9.15"
versions=3.9.15

for version in $versions
do

( # run in separate shell

shortversion=${version%.*}

prefix=$BASEDIR/install/python-$version
moduledirbase=$BASEDIR/modules/python
moduledir=$moduledirbase/$shortversion

# install python
true &&
cd $TMP &&
curl -LO https://www.python.org/ftp/python/$version/Python-$version.tgz &&
tar xzf Python-$version.tgz &&
cd Python-$version &&
./configure --prefix=$prefix &&
make -j 12 &&
make install &&
chmod -R a-w $prefix &&
chmod -R a+rX $prefix &&
rm -fr $TMP &&
mkdir -p $moduledir &&
touch $moduledirbase/.version &&
cat > $moduledir/$version << EOF
#%Module1.0##############################################

conflict        python
conflict        python3

module-whatis   "Python $version"

prepend-path    LD_LIBRARY_PATH $prefix/lib
prepend-path    MANPATH         $prefix/share/man
prepend-path    PATH            $prefix/bin
prepend-path    PKG_CONFIG_PATH $prefix/lib/pkgconfig

module use $BASEDIR/add-modules/py$shortversion
EOF

)

done
