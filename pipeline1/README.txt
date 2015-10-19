#runThisScript.sh: 
#
#Arguments: <reference genome> <interacting loci pair table file, must be comma-separated.>
#
#The steps are follows:

#   Have the reference file's relevant columns saved, then filter out the file of all of its
#   LINC and MIR non-coding protein genes. Both the removed and remaining lines are saved 
#   in separate files. 
#
#   After this,the relevant fields in the given loci pair table are saved in a separate file,
#   then moved into a created directory where it will be split into chunks of 2000 lines each.
#   A list is made of these files, where an awk script will be used to create pbsScripts
#   that will run "bestEstimation.pl" for 5 of the chunks. This program uses the filtered reference genome 
#   "referenceGene.txt" to look up the closest TSS to the positions of the loci, and updates the file table.
#
#
#
#   At the end of the script, the directories produced are removed. Comment
#   out any statement to see the exact files that are made.     
#   An Rscript: countUpStats.R, is used to chart the number of promoters in
#   the table. Epigenetic server doesn't have Rscript installed last time I 
#   attempted to run a R program in it, though it should be easy to count
#   up and graph the data with matlab. 
