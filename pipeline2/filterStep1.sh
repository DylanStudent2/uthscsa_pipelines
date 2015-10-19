#!/bin/bash



echo "Pasting together read pairs, this will take time."

`./combineThings.pl samFiles/ .sam paste`

echo "Filtering commencing"

#Change "testRepository to "samPasted" later on
echo "#PBS -l nodes=1:ppn=1
      #PBS -l walltime=144:00:00
      #PBS -l pmem=20gb
      cd \$PBS_O_WORKDIR                         
      \`./cleanFile.pl samPasted/ .sam\`" > singlePBS.script


echo "submitted script: \"singlePBS.script\" wait for it to finish before continuing"

echo "`qsub singlePBS.script`"

echo "Directories have been made: cleanedReads and failedReads."


