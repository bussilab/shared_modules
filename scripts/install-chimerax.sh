umask 022
BASEDIR=$(cd .. && pwd)

version=1.3

prefix=$BASEDIR/install/chimerax-$version
moduledir=$BASEDIR/modules/chimerax

if ! test -f $prefix/bin/ChimeraX ; then
echo "download and unpack tgz first"
exit 1
fi

true &&
cd $prefix/ &&
! test -h ChimeraX &&
ln -s bin/ChimeraX &&
mkdir -p $moduledir &&
cat > $moduledir/$version << EOF
#%Module1.0##############################################
prepend-path  PATH             $prefix
EOF

