BASEDIR=$(cd .. && pwd)

pyversion=3.9
version=2022.11.29
module=py-base

prefix=$BASEDIR/install/py$pyversion-$module-$version
moduledir=$BASEDIR/add-modules/py$pyversion/$module

packages="
argcomplete networkx numba numpy scipy slackclient slack_sdk pyyaml typing_extensions
pandas scikit-learn matplotlib jupyter jupyterlab
cython
nglview panedr plumed mdtraj barnaba MDAnalysis
pytest pytest-cov pyflakes pylint flake8 pdoc3 mypy nbconvert twine nose
toml
"

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
module load $module/$version

# install packages
true &&
pip3 install --ignore-installed --prefix=$prefix $packages &&
pip3 freeze > $requirements &&
chmod -R a-w $prefix &&
chmod -R a+rX $prefix

