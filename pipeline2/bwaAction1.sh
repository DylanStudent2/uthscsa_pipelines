#!/bin/bash

#Arguments: <directory of fastq files> <fasta-formatted reference genome>  
#This script performs bwa index and bwa aln commands. 


args=("$@")


#This command will take awhile
`./bwa-0.7.12/bwa index -a bwtsw ${args[1]}` 


echo "Indexing has been completed, now aligning files within \"${args[1]}\""

`./general2Commands.pl ./bwa-0.7.12/bwa ${args[0]} .sai aln -t 8 ${args[1]} alignments/`

sleep 1s
echo "`./qsubScript.pl pbsScripts/`"



#Alignment complete, now producing sam files...


