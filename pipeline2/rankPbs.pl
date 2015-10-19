#!/usr/bin/perl -w 
#
# Another script to create pbsScripts, this time 
# it's used to work with adding the fragment sites
# to the reads.
#  
#  Each pbsScript will contain:
#  
#  4 consecutive commands which are written as : 
#
#  ./../rankLoci.pl <splitPiece> <directory containing the splitted files> <path name of the hindIII cutting file to work with, without the extension*>
#
#  * each file should only be extended by the alphanumeric characters of its 
#    chromosome. This (and the rankLoci.pl) script looks up files written as : 
#    /PATH/cuttingSiteFileName.X and will not work if .X included additional
#    characters with it.
#

#Remove previous possible repository of pbs scripts, so that it isn't
#included in the @directories list.
$destination = "pbsRepo/";
if(-d $destination){
   `rm -r $destination`;
}


#Yep!
@directories = `ls -l | grep "^d"`;
chomp(@directories);
#Get an array of the fileList names made within this special directory.
#They're denoted as: "splitPiece_\d\d"

sort @directories;
@splitFiles = `find splitPiece*`;
chomp(@splitFiles);

#Make a pbs repository
mkdir("$destination");

#Create a list of directories to be used for combining together 
#The splitted files of replicants. 
open (DIR, ">dirList.txt") or die "Couldn't create the directory\n";
foreach $dir (@directories){
   #If the directory contains "final" in it, skip it.
   #This case is needed when the user terminates their commands ahead of time,
   #and re-uses the filterStep2.sh script again. When this occurs,
   #additional directories from the previous run are still around.
   if($dir =~ /final|$destination/){
      next;
   }
   $dir =~ s/.*\s(\S+)$/$1/;
   print(DIR "final$dir/\n"); 

   open(FILE,">>$destination$dir.Script") or die "Couldn't make $dir.$file.Script\n";    
   print(FILE "#PBS -l nodes=1:ppn=4
               #PBS -l walltime=144:00:00
               #PBS -l pmem=20gb
               cd \$PBS_O_WORKDIR\n");
       
   foreach $file (@splitFiles){
      print(FILE "./../rankingLoci.pl $file $dir/ $ARGV[0]\n");
   }
   close(FILE); 
}

