#!/bin/sh

export USER="$(whoami)"

ENV_FILE=".bash_profile"
ENV_PATH="${HOME}/"${ENV_FILE}
if [[ ! -f ${ENV_PATH} ]]; then echo "$ENV_PATH does not exist" >&2; exit 1; fi

export WORKDIR=/storage/gpfs_data/dampe/users/ecatanzani/MyRepos/cnaf-jsubmission-local-svn/trunk
if [[ ! -d $WORKDIR ]]; then echo "$WORKDIR does not exist" >&2; exit 1; fi

export EXEC=${WORKDIR}/ExeSW/Release/job_exe
if [[ ! -f $EXEC ]]; then echo "$EXEC does not exist" >&2 ; exit 1; fi

SUBMITDIR=${WORKDIR}/sh_files
if [[ ! -d $SUBMITDIR ]]; then echo "$SUBMITDIR does not exist" >&2; exit 1; fi

TEMPLATE=${SUBMITDIR}/template.sh
if [[ ! -f $TEMPLATE  ]]; then echo "$TEMPLATE does not exist" >&2; exit; fi

export OUTDIR=${WORKDIR}/Results
if [[ ! -d $OUTDIR ]]; then mkdir -pv ${OUTDIR}
else echo "Output directory will be: $OUTDIR"; fi

export FILES=$@

export SETVAR=${WORKDIR}/
echo "Copying ENVIRONMENT variable to stprage dierctory: "
cp -v ${ENV_PATH} ${SETVAR}
SETVAR+=$ENV_FILE

sh ./template.sh

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

Now, all is set. We substitute the value of the variables into the template file using sed command and we locally submit the job.

'
