BASEDIR=$(cd .. && pwd)

for cuda in 9.0 9.1 10.0 10.1
# 11.0 does not work for some reason 2/2/2022
do
(

pyversion=3.9
version=2022.11.29-cu-$cuda
module=cudamat

prefix=$BASEDIR/install/py$pyversion-$module-$version
moduledir=$BASEDIR/add-modules/py$pyversion/$module

#install modulefile
mkdir -p $moduledir

cat > $moduledir/$version << EOF
#%Module1.0##############################################

module-whatis   "Python modules $version"
prepend-path    PATH            $prefix/bin
prepend-path    PYTHONPATH      $prefix/lib/python$pyversion/site-packages
prepend-path    LD_LIBRARY_PATH $prefix/lib:$prefix/lib64
depends-on cuda/$cuda
depends-on py-base
EOF

module use $BASEDIR/modules
module load python/$pyversion
module load py-base
module load cuda/$cuda
module load $module/$version

# install packages
true &&
pip3 install --ignore-installed --prefix=$prefix https://github.com/cudamat/cudamat/archive/21baa0a82f189fae40cab3ab607c11cabfee8899.tar.gz &&
chmod -R a-w $prefix &&
chmod -R a+rX $prefix
)
done
