#!/usr/bin/perl -w 
#
#This file can be qsub'ed by one pbes script
#
#This program filters out low quality reads and 
#any instance of inter-chromosomal interactions. 
#
#
            #This will be a list of repository names
if($#ARGV != 1) {
   die "Argument: <directory of files> <extension name>\n";
}

@lines = `find $ARGV[0] | grep -P \"$ARGV[1]\$\"`;
chomp (@lines);

$fail    = "failedReads";
$success = "cleanedReads";

if(-d "$fail"){
   `rm -r \"$fail\"`;
}
if(-d "$success"){
   `rm -r \"$success\"`;
}

mkdir("$fail");
mkdir("$success");

foreach $file (@lines){
   #FORKING START  
   if($pid = fork){
      next;
   }
   elsif(defined $pid){
    
   open (FILE, "<$file") or die "Cannot find $file";
   $file =~ s/.*\/(\w+)\..*/$1/;
  
   #These are our files that will be created from this filtering function. 
   open(MISMATCH, ">$fail/$file.mismatch.txt") or die "silly mismatch.txt could not be made\n";
   open(UNALIGNED, ">$fail/$file.alignment.txt") or die "bad Alignment could not be made\n";
   open(BADQUALITY, ">$fail/$file.quality.txt") or die "Couldnt bother with bad quality file\n";
   open(CLEAN, ">$success/$file.cleaned") or die "Couldn't create \"$file.cleaned\" for some reason \n";
   open(MYSTERY, ">$fail/$file.header.txt") or die "Hmmmm";

   while (<FILE>){
      #Let's get rid of those sequence reads!
      #Make sure the matched expression isn't the read name (which is characterized by:  "SRR\d+.\d+\.\d")
     # s/(?|(?<=SRR\d+\.\d+\.\d\s(?|\S+\s){8})[\S]{20,}\s+[\S]{20,}\s+|\t/ /g;
      s/(SRR\d+\.\d+\.\d\s(\S+\s){8})[\S]{20,}\s+[\S]{20,}/$1/g; 
      s/\t/ /g;

      if(/SRR.*(chr\w+)\s+\d+\s+(\d+).*SRR.*\s+(chr\w+)\s+\d+\s+(\d+)/){
      
         if($2 < 30 || $4 < 30){
            print(BADQUALITY "$_");
         }
         elsif($1 eq $3){
            print(CLEAN "$_");
         }
         else{
            print(MISMATCH "$_");
         }
      }
      elsif(/^@/){
          print(MYSTERY "$_");
          #IGNORE HEADERS
      }
      else{
         print(UNALIGNED "$_");
      }
   }#End of the child process
      close(MISMATCH);
      close(UNALIGNED);
      close(BADQUALITY);
      close(MYSTERY);
      close(CLEAN);
      exit; 
   }
   else{
      die "Forking error!\n";
   }

}

#Parent process must wait for children, wish I could have this written in one line like in C!
while(wait != -1){

}
