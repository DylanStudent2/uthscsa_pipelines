#!/usr/bin/perl -w

#Split each file into 20 separate pieces!

use POSIX;

#Grab the list of files created from the awk script in filterStep2.sh
@arrayList = split(/\n/, `ls | grep -P "chr[0-9XY]+.*\.tmp"`);

#For every file name, build a smaller hash which will be used to make directories 
#corresponding to the file name's unique string 
#
foreach $item (@arrayList){  # |
   $string = $item;    #Where  V is the particular part of the string in the name that makes the file unique.
   $string =~ s/chr[0-9XY]+\.(\w+)\.\w+\.tmp/$1/;
   $hash{$string} = $string;
    
}

#For every particular file, make a directory for it and move all chromosome files associated with it into its directory
foreach $line (keys %hash){
   
   if(-d "$line"){
      `rm -r $line`;
   }
   mkdir("$line");
   `mv chr*.$line.*tmp $line/`;

   chdir("$line");

   $name = "splittedOutput/";

   if(-d "$name"){
      `rm -r $name`;
   }

   mkdir ("$name");
   chdir ("$name");
#Have each chromosome file of a particular sam file split into 20 pieces; there'll be 
#20x24 = 480 files to process once this is over. 
   @files = `find ../ | grep -P ".*\.tmp"`;
   chomp(@files);
foreach $item (@files){

   $numLines = `wc -l $item`;
   $numLines =~ s/(\d+)\s+.*/$1/;
   $amount = ceil($numLines/20);

   $fileName = $item;
   $fileName =~ s/.*(chr[0-9XY]+).*/$1/;
    
      #Each splitted item will have the prefix chr\w+_\d+
   `split -d -l $amount $item $fileName\_`;

}
   
   #Remove the files from previous directory 
   #!!!!!!!!!!!!!!!!!---------------This will glob the current directory as well, giving a "cannot remove <dir name>" message
   #Just ignore it, in the same way mv * <dir name> gives the "cannot move <dir name> to itself" message
   `rm ../*`;

   #Move all the pieces back a step
   `mv * ../`;  

   #Leave temporary repository
   chdir("../");
   #Remove the temporary repository
   rmdir("$name");
   #Go back to cleanedFiles directory.
   chdir("../");
}


@array = `ls $string/ | sort -k1.4n,1.5n`;

open(FILE, ">splitsList.txt") or die "Could not create the split list\n";
foreach $item(@array){

  print(FILE "$item");

}

#Separate the particular split file into four different pieces!
#Maybe I should divide the file into more pieces later?
`split -d -l 80 splitsList.txt splitPiece_`;

