#!/bin/sh      #Before bash were selected ! Are there commands tipical just for bash ??

FILELIST="filelist.txt"
BATCH=50                                                                   #"BATCH" sets the number of how many files evaluate together

compute_free() {
    FREE=$MAXPEND
    compute_jobs
    let FREE-=$JOBS
}

compute_jobs() {
    JOBS=`qstat $QUEUE 2>&1 | egrep "WAIT|RUN" | wc -l`
}

compute_maxpend() {
    THRESHOLD_FILE=".THRESHOLD_PENDING"
    SHARPNESS=10
    echo "1000" > $THRESHOLD_FILE                                          #1000 is the maximum number of pending jobs 
    MAXPEND=1000
    MAXPENDL=$MAXPEND
    MAXPENDDEC=$MAXPEND
    let MAXPENDDEC/=$SHARPNESS
    let MAXPENDL-=MAXPENDDEC
}

compute_maxpend

SUBMITTED=0
compute_free
compute_jobs

files=""
nfiles=0

while read FILE
  do
    if [[ $SUBMITTED -gt $FREE ]]; then
        while [ $JOBS -gt $MAXPENDL ]; do                                # MAXPENDL (MAXPEND-20%) to avoid to "release" the 'wait' just for one even
            echo "$JOBS job waiting..."
            sleep 10
            compute_jobs
            compute_maxpend
        done
        SUBMITTED=0
        compute_free
        echo "s=$SUBMITTED l=$FREE"
    fi
    files="$files $FILE"
    let nfiles+=1
    if [[ $nfiles -ge $BATCH ]]; then
        echo "Launching $I ..."
        let SUBMITTED+=1
        ./submit_one_job.sh $files
        files=""
        nfiles=0
    fi
done <${FILELIST}

#launch last batch

echo $nfiles
if [[ $nfiles -ge 1 ]]; then
    ./submit_one_job.sh $files
fi
