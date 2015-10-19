Here's the following steps to using this pipeline:
Make sure to use this pipeline in an empty directory, where 
only the desired .sra files are located.

Be sure to have bwa and sra toolkit for the first steps


1.
   sraAction.sh
   
   For every replicant, make a directory corresponding to it and move all 
   associated .sra files to the appropiate directory. 
   
   execute as:
  
   ./sraAction.sh <directory-1> ...<directory-n>
   
   stores the fastq files produced into the directory: fastqRepo

2.  
   - bwaAction1.sh
   
   This script will create the index of the fastq files for re-alignment
   followed by creating the .sai files. The .sai files are made from a
   cluster and stored in the directory "alignments/", and must also 
   be waited for completion before moving on to bwaAction2.sh. 

   execute as :
  
   ./bwaAction1.sh fastqRepo/ (or wherever the fastq files are stored)
<fasta-formatted reference genome> 
 

   - bwaAction2.sh

   This will create the sam files, also uses a cluster to produce the files.

   execute as:

                                                                       "alignments/"
   ./bwaAction2.sh <dir of fastq files> <fasta-formatted ref genome> <.sai file directory>



3. 
   - filterStep1.sh
   
   This part of the script combines each pair of a read together, before
   submitting a single PBS script that runs the program "cleanFile.pl" which
   uses forking to filter out the sam files. 
   
   Produces two directories: cleanedReads and failedReads, where failedReads
   are sam files with a lower than 30 mapping quality score, an unaligned 
   read, or are interchromosomal. The files have an extension detailing 
   what type of failure they have, though interchromosomal interactions
   with a low quality score are considered low quality score files. 

   execute with no arguments.


   - filterStep2.sh

   This part of the script splits up the sam files twice: first by separating 
   chromosomes into its own file chunk, then splitting each of those chunks
   into 20 smaller chunks. Once this is done, pbs Scripts are submitted 
   for each sam file as a whole, and runs 80 processes at a time for every
   node. It looks up cutting site files according to the chromosome, 
   to add a fragment site to every read within a pair. 

 

**************IMPORTANT: -------------**************************** 
 the argument this script takes in is the path of the cutting site file used.
   The particular path must include the filename without the extension that
   specifies the chromosome that is involved.
#    There should be multiple cutting site files available, based on a
#    particular chromosome. There should be no additional extension appended 
     at the end of the file; only the chromosome should be the extension.
    
     Example argument:
#    /PATH/cuttingSiteFileName will work, and will not work if it were 
     /PATH/cuttingSiteFileName.X or
#    /PATH/cuttingSiteFileName.siteCutExtensionName
#    

   - filterStep3.sh
    
   Combines all the splitted files together, then re-orders the 
   read pairs where the first pair is whichever read has the lower
   fragment site, normal strand, or read position. This is also done
   for sorting the entire replicant files. Once this is done, the files
   have their duplicates and reads pairs with same fragments separated
   from the rest of the reads. The reads are moved to the path:
   "replicants/filtered"

4.
   makeMatrices.sh

   Takes in input when executed by itself, it's simply the bin number. 

   It's self-explanatory, though when it runs "normalize.pl"
   to use topDom and hicorrector scripts to make the normalized and domain
   matrices, it gives error output.


Instructions on setting up the matlab program:

Make sure to have the program running in the current directory.

On the command window, enter the following commands to open a image window:



chr1 = dlmread('matrices/Chromosome1.txt', ',');
imagesc(chr1)


Once the window is shown, go on Edit: Colormap
           Go to tools: standard colormaps: gray scale
           After that , set the color data max to 1 and min to 0
           Have the left most tab at white and right-most as red
           Click ok then exit out. Once this is done, you may
           get the colormap and assign it to a variable. Run
           "colorMapHiC=get(gcf,'colormap');" to store this
           scheme into variable "colorMapHiC".

           Do these same
           steps for getting the domain color scheme, though the
           color data min and max should be left as is , as they should
           be at low values to begin with. Also: click on the middle
           part of the color range and make newly created tab blue.

           When these color scheme variables are made, you can then
           automate the creation of the images by entering on the
           command window:

           for(n=1:22) [PRESS ENTER KEY for every line]
             variable = sprintf('Chromosome%s.txt,n)
             createImages(variable,<Name of HiC variable>, <Name of Dom variable>)
            end

         for Chromosomes X and Y, just call createImages twice for each of
         them in the command Window, such as :
         "createImages('ChromosomeX.txt', <HiC var>, <Dom var>)"


