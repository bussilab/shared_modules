umask 022
BASEDIR=$(cd .. && pwd)

pyversion=3.9
module=py-base
version=2023.04.04
#stackon_version=2022.11.29

prefix=$BASEDIR/install/py$pyversion-$module-$version
moduledir=$BASEDIR/add-modules/py$pyversion/$module

packages="
argcomplete networkx numba numpy<1.24 scipy slackclient slack_sdk pyyaml typing_extensions
pandas scikit-learn matplotlib jupyter jupyterlab
cython
nglview panedr plumed mdtraj barnaba MDAnalysis
pytest pytest-cov pyflakes pylint flake8 pdoc3 mypy nbconvert twine nose
toml
acpype
asciinema pygments
ipython rdkit biopython pydca PlumedToHTML
sympy regex openpyxl multiprocess
tqdm
"

requirements=$module-$version-requirements.txt

test -d $BASEDIR/modules/python/$pyversion || {
  echo "python $pyversion not installed yet"
  exit 1
}

test -f $requirements && {
  packages=$(cat $requirements)
}

module purge
module use $BASEDIR/modules
module load python/$pyversion
test -n "$stackon_version" && module load $module/$stackon_version

export PATH=$prefix/bin:$PATH
export PYTHONPATH=$prefix/lib/python$pyversion/site-packages:$PYTHONPATH
export LD_LIBRARY_PATH=$prefix/lib:$prefix/lib64:$LD_LIBRARY_PATH

# install packages # might need --use-deprecated=legacy-resolver
true &&
mkdir -p $prefix &&
PYTHONUSERBASE=$prefix pip3 install --user -U $packages &&
pip3 freeze > $requirements &&
chmod -R a-w $prefix &&
chmod -R a+rX $prefix 

#install modulefile
mkdir -p $moduledir

cat > $moduledir/.$version << EOF
#%Module1.0##############################################

module-whatis   "Python modules $version"
$(test -n "$stackon_version" && grep prepend-path $moduledir/$stackon_version)
prepend-path    PATH            $prefix/bin
prepend-path    PYTHONPATH      $prefix/lib/python$pyversion/site-packages
prepend-path    LD_LIBRARY_PATH $prefix/lib:$prefix/lib64
EOF

