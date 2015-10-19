#!/bin/bash

args=("$@")

#     Arguments: <path of cutting site file including the file without its extension>
#    
#    This script uses a program (rankingLoci.pl) which looks up files written as : 
#    /PATH/cuttingSiteFileName.X and will not work if .X included additional
#    characters with it.

echo "Splitting the files up for improved throughput"

#Change to "cleanedReads" later
cd clTestReads
#
awk '{print > $3"."FILENAME".tmp"}' *.cleaned
echo "`./../splitFilesFurther.pl`"

echo "Now submitting pbs scripts to assign fragment regions"

echo "`./../rankPbs.pl ${args[0]}`"

echo "`./../qsubScript.pl pbsRepo/`"
