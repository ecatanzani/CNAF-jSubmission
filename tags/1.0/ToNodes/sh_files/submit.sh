#!/bin/sh      

FILELIST="/storage/gpfs_data/dampe/users/ecatanzani/MyRepos/cnaf-jsubmission-svn/trunk/20180501.txt"
BATCH=50

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
    echo "1000" > $THRESHOLD_FILE 
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
        while [ $JOBS -gt $MAXPENDL ]; do                                # MAXPENDL (MAXPEND-20%) to avoid to "release" the 'wait' just for one event
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

: '
  COMMENTS ON SH FILE

  This sh file permits to start and manage jobs.
  Will be used other sub-shell scripts, so the variable management will be described.
  
  The maximum number of avaiable jobs is 1000 ("MAXPEND"), while for performance reasons a single job should process more than one file, precisely a number like "BATCH" variable (we fix that value to 50)
  So we start with an empy string "files", corresponding to a zero value for "nfiles". While we are reading the file list, conteining all the paths of the lifes to process, "files" and "nfiles" are updated.
  Once the nfiles is bigger than BATCH a job could start, with the big string files as argument. "files" contains the path, separated by a space by construction, of each single file to process.
  After starting a job, procedure we will explain in the next shell documents, both "files" and "nfiles" return to their original value, respectively an empty string a zero value variable.

  Before updating these variables, and so start a new job if the case, we have to check if the submmitted jobs are more than the free ones.
  We define a new variable, "MAXPENDL", as "MAXPEND" -20%. So, if submitted jobs are more than free ones, we continue to wait until at least 20% of free "space" is avaiable.
  This tecnique is used to avoid to "release" the "wait" just for one event; at the countrary if just a new free place shows up, and we immediately start a new job, we will probabily have to wait soon again for a new job submission. 
  
  Once whe list has been read, probably some file has noot ben processed; so we winish to process these files. In this case the nuber of processed files will be less that "BATCH" value, infact they have not procecces into the while loop.  

' 