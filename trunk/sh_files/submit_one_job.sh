#!/bin/sh

USER="$(whoami)"

#ENV="${HOME}/.bash_profile"
#if [[ ! -f $ENV ]]; then echo "$ENV does not exist" >&2; exit 1; fi

ENV_FILE=".bash_profile"
ENV_PATH="${HOME}/"${ENV_FILE}
if [[ ! -f ${ENV_PATH} ]]; then echo "$ENV_PATH does not exist" >&2; exit 1; fi

WORKDIR=/storage/gpfs_data/dampe/users/ecatanzani/MyRepos/cnaf-jsubmission-svn/trunk
if [[ ! -d $WORKDIR ]]; then echo "$WORKDIR does not exist" >&2; exit 1; fi

EXEC=${WORKDIR}/ExeSW/Release/job_exe
if [[ ! -f $EXEC ]]; then echo "$EXEC does not exist" >&2 ; exit 1; fi

SUBMITDIR=${WORKDIR}/sh_files
if [[ ! -d $SUBMITDIR ]]; then echo "$SUBMITDIR does not exist" >&2; exit 1; fi

TEMPLATE=${SUBMITDIR}/submit.job.template
if [[ ! -f $TEMPLATE  ]]; then echo "$TEMPLATE does not exist" >&2; exit; fi

OUTDIR=${WORKDIR}/Results
if [[ ! -d $OUTDIR ]]; then mkdir -pv ${OUTDIR}
else echo "output dir will be $OUTDIR"; fi

QUEUE=dampe_usr

FILES=$@

NAME="Creation_Histos"

JOB_DIR=${SUBMITDIR}/jobs
if [[ ! -d $JOB_DIR ]]; then mkdir -pv ${JOB_DIR}; fi

LOG_DIR=${SUBMITDIR}/log
if [[ ! -d $LOG_DIR ]]; then mkdir -pv ${LOG_DIR}; fi

echo "Copying ENVIRONMENT variable to stprage dierctory: "
SETVAR=${WORKDIR}/
cp -v ${ENV_PATH} ${SETVAR}
SETVAR+=$ENV_FILE

JOBNAME="job_${NAME}_${RANDOM}"
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
chmod 777 ${JOB}

echo " ----- $NAME"
CMD="bsub -n 1 -q ${QUEUE} -u ${USER} -J ${JOBNAME} -oo ${LOGFILE} -e ${ERRFILE} ${JOB}"
echo ${CMD}
${CMD}


: '                                                                                                                                                                                                                                                              
  COMMENTS ON SH FILE

  In this file are specified many variables. Tehy will be used both by the tremplate file and to manage job execution.
  In particularly important to copy the local environment variables in the user home to the storage diretcory, while home is not readable from nodes.
  This is performed by te following code:
     
    //////////////////////////////////////// 

     ENV_FILE=".bash_profile"
     ENV_PATH="${HOME}/"${ENV_FILE}
     if [[ ! -f ${ENV_PATH} ]]; then echo "$ENV_PATH does not exist" >&2; exit 1; fi                   
     SETVAR=${WORKDIR}/
     cp -v ${ENV_PATH} ${SETVAR}                                                                                        
     SETVAR+=$ENV_FILE

    ////////////////////////////////////////

  "WORKDIR" is the working directory, me can say the main directory of the project. This is like a "home path", we could use to navigate to other sub-diretcories.
  
  "EXEC" is the absolute path, referred to the "WORKDIR", of the binary executable file containing the instructions to operate on each file of the list.
  
  To this file is pased, as argument, a number of files like "BATCH"; using the command FILES=$@ we expands the positional parameters, starting from one.
  This new variables "FILES" will be used as argument for the executable file through the template file.
  
  "SUBMITDIR" is a sub-diretcory containing all the shell files tregarding job submission.
  
  "OUTDIR" is the output directory, where all jobs results will be saved.
  
  "TEMPLATE" is the absolute path, again regarding "WORKDIR", of the template file. Template file is then used to ferform all the job operations and to execute the binary exe files regarding file data analysis.
  Template file is particularly important; this file uses many of the variables here defined, that change from job to job, using sed command. This one substitutes the "job-specific" variables to the general one of the template, permitting to smartly perform operations.
   
  "QUEUE" defines the nodes regarding to DAMPE where to execute jobs.

  "NAME" is the family name for the jobs. All jobs will have this common name, while they regard the same kind of operations. Maybe useful, however, to distinguish each jobs from the others, maybe to kill it is anything goes wrong.
  To distinguish each job the following code is used:

    ////////////////////////////////////////
  
    NAME="Creation_Histos"
    JOBNAME="job_${NAME}_${RANDOM}"
    JOB=${JOB_DIR}/${JOBNAME}.job

    ////////////////////////////////////////  

  As you can see from the previous code lines, a random number is used to recognise each single job. 

  Now, all is set. We substitute the value of the variables into the template file using sed command and we submit the job with "bsub" command. 
                                                                                                                                                                                
'
