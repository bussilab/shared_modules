BASEDIR=$(cd .. && pwd)

pyversion=3.9
jax_version=0.2.19
jaxlib_version=0.1.70+cuda101
module=jax

version=$jax_version-jaxlib-$jaxlib_version
prefix=$BASEDIR/install/py$pyversion-$module-$version
moduledir=$BASEDIR/add-modules/py$pyversion/$module

packages="
jaxlib==$jaxlib_version
jax==$jax_version
"

test -d $BASEDIR/modules/python/$pyversion || {
  echo "python $pyversion not installed yet"
  exit 1
}


#install modulefile
mkdir -p $moduledir

cat > $moduledir/$version << EOF
#%Module1.0##############################################

module-whatis   "jax $jax_version and jaxlib $jaxlib_version"
prepend-path    PATH            $prefix/bin
prepend-path    PYTHONPATH      $prefix/lib/python$pyversion/site-packages
prepend-path    LD_LIBRARY_PATH $prefix/lib:$prefix/lib64
EOF

module purge
module use $BASEDIR/modules
module load python/$pyversion
module load py-base
module load $module/$version
module load cuda/10.1

# install packages
true &&
pip3 install --prefix=$prefix $packages -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html &&
chmod -R a-w $prefix &&
chmod -R a+rX $prefix

