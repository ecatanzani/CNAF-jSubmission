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
