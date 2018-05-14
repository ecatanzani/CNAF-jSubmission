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

: '
    COMMENTS ON SH FILE

This is the template file, used to perform all the operations of the job.

The function run_exec execute the binary file (before compiled apart) to strart data analysis.
A new random diretcory is created; here all the jobs results are saved, and then moved to the output diretcory. Use use a random diretcory as a sandbox to distinguish are results from other people ones.
This directory, after files moving, will be deleted.

All environment variables are loaded and "FILES" variables contains all the "BATCH" files to analyse, separated by a space. Now two options are avaiable.
1 - we can do a loop on all these files (before splited into positional arguments in "submit_one_job.sh" file) and for each one call "fun_exec" function. Here the code to do that:

/////////////////////////////////

for f in $FILES
do
run_exec $f
done

/////////////////////////////////

This is not efficient, so we have not used this tecnique.

2 - we can create a list file and pass it to the function as unique argument. The analysis fotware wil have a function to open this file list and obtain each single path. The code is th one effectively used in the file, here copied:

/////////////////////////////////

FILES="_FILES_"
echo $FILES >> ./lista.dat
run_exec lista.dat
rm -fv lista.dat

/////////////////////////////////

As you can see the list is then deleted.

'
