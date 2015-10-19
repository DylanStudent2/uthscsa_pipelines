#!/bin/bash

args=("$@")



#ARGUMENTS: directories that contain all the .sra files for a replicate
                                  # argument
#Run time: around 1 hour

for dir in "$@"; do

   `./generalCommands.pl ./sratoolkit.2.5.1-centos_linux64/bin/fastq-dump $dir .sra -I --split-files`

   echo "`./qsubScript.pl pbsScripts/`"

done


#This part of the script may not submit everything,depending on whether certain fastq files have been
#established once this part executes. There can be numerious .sra files
#queued in the pbs cluster, which means the particular fastq files
#from them haven't been made yet. Be sure to move any fastq files that are 
#made from this script into the 
#directory before proceeding to the next steps. 


#Sleep for 30 minutes before executing rest of the script.
#You may change it to however you want, with s, h, or d being 
#different suffixes for seconds, hours, and days.
#I'll probably make a perl script to continuously check for any 
#Submitted jobs that are still in Q status, and if so, continue sleeping. 
sleep 30m 


if [ ! -d "fastqRepo/" ] 
then 
   mkdir "fastqRepo/"
fi


echo "Moving the files into a directory: \"fastqRepo\". If you had any previous fastq 
      files within the directory this script was run in, those have also been moved to the directory!"

#Make sure no other .fastq files from somewhere else outside of this script 
#Are not in the same directory as this script. 
`mv *.fastq fastqRepo/`


