#routine to create filelist for job submission

import os
import sys
import re
import argparse

#parser = argparse.ArgumentParser(description='Routine to create list of DAMPE files')
#parser.add_argument('rootdir',help='Root directory that contains the original files')
#parser.add_argument('outputfile',help='Output file that will contain the list')
#parser.add_argument('-v','--verbose', help='Verbosity', action="store_true")
#args=parser.parse_args()
#rootdir=args.rootdir
#outfilename=args.outputfile
#verbose=args.verbose

def checkifexists( filename, outputdir ):
    run=os.path.basename( filename )
    filetocheck=outputdir+"/all/"+run.replace(".root","_SBI.root")
    #    print filetocheck
    if( os.path.isfile( filetocheck ) ):
        return True
    else:
        return False

    
verbose=True
inputdir="/storage/gpfs_ams/dampe/data/FM/FlightData/2A/releases/5.4.0"
outputdir="/storage/gpfs_ams/dampe/users/vvagelli/dampepgsw/trunk/SBI/output_5_4_0_v2"
outfilename="tempfilelist.temp"

if( os.path.isfile( outfilename ) ):
    print "%s exists. Will be overwritten" % (outfilename)
outfile = open(outfilename,"w")

nn=0
for folder, subs, files in os.walk(inputdir):
    for ff in files:
        if ff.endswith(".root"):
            fname = os.path.join( folder, ff )
            #print fname
            #print ff            
            exists=checkifexists( ff, outputdir )
            if not exists:
                outfile.write( "%s\n" % (fname) )
                print "%s\n" % (fname)
                nn += 1
            if verbose and nn%100 == 0:
                print nn
print "Writing %s...." % (outfilename)
print "%d files found" % (nn)                        
                        
