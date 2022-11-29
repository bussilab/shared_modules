BASEDIR=$(cd .. && pwd)

pyversion=3.9
version=0.0.40
module=py-bussilab

prefix=$BASEDIR/install/py$pyversion-$module-$version
moduledir=$BASEDIR/add-modules/py$pyversion/$module

packages="bussilab==$version"

requirements=$module-$version-requirements.txt

test -d $BASEDIR/modules/python/$pyversion || {
  echo "python $pyversion not installed yet"
  exit 1
}

test -f $requirements && {
  packages=$(cat $requirements)
}

#install modulefile
mkdir -p $moduledir

cat > $moduledir/$version << EOF
#%Module1.0##############################################

module-whatis   "Python modules $version"
prepend-path    PATH            $prefix/bin
prepend-path    PYTHONPATH      $prefix/lib/python$pyversion/site-packages
prepend-path    LD_LIBRARY_PATH $prefix/lib:$prefix/lib64
EOF

module use $BASEDIR/modules
module load python/$pyversion
module load py-base
module load $module/$version

# install packages
true &&
pip3 install --no-deps --ignore-installed --prefix=$prefix $packages &&
chmod -R a-w $prefix &&
chmod -R a+rX $prefix

