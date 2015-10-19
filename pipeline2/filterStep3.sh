#!/bin/bash

# This part of the script combines all the files together, where each read 
# pair (and entire file)  is sorted according to chromosome, lowest fragment,
# strand, and read position. The end product are the replicant files, which 
# are a combination of all the sam files associated with it, with duplicates 
# removed.
#


   #change to cleanedReads later
cd clTestReads/

#Combine all the splitted files.
echo "`./../mergeFiles.pl`"

cd ../

mkdir "lastSams/"

mv clTestReads/*.sam lastSams/

ls lastSams > fileList.sam.txt

echo "Re-arranging pair reads!"
echo "`./pairOrder.pl fileList.sam.txt lastSams/`" > finalList.txt 

rm fileList.sam.txt

echo "Creating replicant files"
echo "`./mergeIntoReplicants.pl`" 

if [ -d "replicants" ]; then
   rm -r "replicants"
fi

mkdir "replicants"

mv Replicant* replicants

ls replicants > finalList.txt


#Submitting Script: 
echo "#PBS -l nodes=1:ppn=1
      #PBS -l walltime=144:00:00
      #PBS -l pmem=20gb
      cd \$PBS_O_WORKDIR                         
      \`./removeDuplicates.pl replicants/ finalList.txt\`" > singlePBS.script

echo "`qsub singlePBS.script`"


echo "submitted script: \"singlePBS.script\" wait for it to finish before continuing"
sleep 1s
echo "The results of the files should be stored within path: \"replicants/filtered/\""


