#!/bin/sh                                                                                #Select the default interpreter for the bash code

USER="$(whoami)"                                                                         #Obtain user's name

ENV="${HOME}/set_env.sh"                                                                 #This is the environment variable. While home directory is not redeable from nodes, I have to export it
if [[ ! -f $ENV ]]; then echo "$ENV does not exist" >&2; exit 1; fi

WORKDIR=${DAMPEPG}/SBI                                                                   #This is the working directory
if [[ ! -d $WORKDIR ]]; then echo "$WORKDIR does not exist" >&2; exit 1; fi

EXEC=${WORKDIR}/exe/buildSBI                                                             #In this case "buildSBI" is the name of the executable file
if [[ ! -f $EXEC ]]; then echo "$EXEC does not exist" >&2 ; exit 1; fi

SUBMITDIR=${WORKDIR}/submit/CNAF
if [[ ! -d $SUBMITDIR ]]; then echo "$SUBMITDIR does not exist" >&2; exit 1; fi

TEMPLATE=${SUBMITDIR}/submit.job.template                                                #Template file for jobs computation
if [[ ! -f $TEMPLATE  ]]; then echo "$TEMPLATE does not exist" >&2; exit; fi

OUTDIR=${WORKDIR}/6.0.0.v5                                                               #Select what will be the output directory after jobs evaluation
if [[ ! -d $OUTDIR ]]; then mkdir -pv ${OUTDIR}
else echo "output dir will be $OUTDIR"; fi

QUEUE=dampe_usr                                                                          #This select the queque to use into CNAF service

FILES=$@                                                                                 #Arguments for the sh file I'm calling to jobs' submission

                                                                                         #@ Expands to the positional parameters, starting from one. When the expansion occurs within double quotes,
                                                                                         #each parameter expands to a separate word. That is, "$@" is equivalent to "$1" "$2" ...

NAME="SBI_`basename $1 .root`"                                                           #Jobs' name !

JOB_DIR=${SUBMITDIR}/jobs
if [[ ! -d $JOB_DIR ]]; then mkdir -pv ${JOB_DIR}; fi

LOG_DIR=${SUBMITDIR}/log
if [[ ! -d $LOG_DIR ]]; then mkdir -pv ${LOG_DIR}; fi

SETVAR=${WORKDIR}/set_env.sh
cp -v ${ENV} ${SETVAR}                                                                  #Copy the set_var.sh locally in storage, because /home is not mounted on the nodes

JOBNAME="job_${NAME}"                                                                   #Assign name to the job
JOB=${JOB_DIR}/${JOBNAME}.job
ERRFILE=${LOG_DIR}/${JOBNAME}.err
LOGFILE=${LOG_DIR}/${JOBNAME}.log

rm -fv ${ERRFILE}
rm -fv ${LOGFILE}
cp -v ${TEMPLATE}                           ${JOB}
sed -i "s%_SETVAR_%${SETVAR}%g"             ${JOB}
sed -i "s%_EXEC_%${EXEC}%g"                 ${JOB}
sed -i "s%_FILES_%${FILES}%g"               ${JOB}
sed -i "s%_OUTDIR_%${OUTDIR}%g"             ${JOB}
chmod 777 ${JOB}                                                                       #Set right persmission to the job

echo " ----- $NAME"
CMD="bsub -n 1 -q ${QUEUE} -u ${USER} -J ${JOBNAME} -oo ${LOGFILE} -e ${ERRFILE} ${JOB}"
echo ${CMD}
${CMD}
