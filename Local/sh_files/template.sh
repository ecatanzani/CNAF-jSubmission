#!/bin/sh

run_exec () {
    FILELIST=$1
    CMD="$EXEC $FILELIST"; echo ${CMD}; ${CMD};
}

echo "`whoami` @ `hostname` : `pwd`"

CMD="source $SETVAR"; echo ${CMD}; ${CMD};

echo " ------------------------ "
echo " ---------- ENVS -------- "
echo " ------------------------ "
echo ""
env
echo ""
echo " ------------------------ "
echo " ------------------------ "
echo ""

HOME=`pwd`
UNIQUE="$$_$RANDOM"
SANDBOX=$HOME/../SandBox/$UNIQUE
while [[ -d $SANDBOX ]]; do
    UNIQUE="$$_$RANDOM"
    SANDBOX=$HOME/../SandBox/$UNIQUE
    echo "\n\n into while loop \n\n"
done
mkdir -vp $SANDBOX
cd $SANDBOX
pwd

FILES="$FILES"
echo $FILES >> ./lista.dat
run_exec lista.dat
rm -fv lista.dat

ls -altrh
mv -v *.root ${OUTDIR}
rm -rfv "$SANDBOX"
