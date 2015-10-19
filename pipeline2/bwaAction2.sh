#!/bin/bash


#The second bash script: takes in <dir of fastq files> <reference file> <dir of alignment files>

args=("$@")

echo "Creating the sam files:"

`./general2Commands.pl ./bwa-0.7.12/bwa ${args[2]} ${args[0]} .sam samse ${args[1]} samFiles/` 

echo "`./qsubScript.pl pbsScripts/`"

echo "The Sam files should be made."
