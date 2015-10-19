#!/usr/bin/perl -w 

#Make the Order of read pairs according to fragment, strand, and position.
if($#ARGV != 1 || $ARGV[1] !~ /\/$/){
   print("Arguments: <File List> <directory name with slash at end>\n");
   exit; 
}

open(FILE, "<$ARGV[0]") or die "Uh Oh, couldnt access $ARGV[0]!\n";

open(FACTORY, ">>wasteBasket.txt") or die "The trash can could not be made.\n";

while(<FILE>){
   chomp();
   
   open(THING, "<$ARGV[1]$_") or die "Could not access $ARGV[1]$_\n";
   open(OUTPUT, ">$_.final") or die "Couldn't create output file\n";

   #Print this out, where it'll be redirected into a list 
   #Advantage of this over different methods is that only the files
   #that have been recently worked on will be placed into the list. 
   
   print("$_.final\n");   

   @lines = <THING>;
   chomp(@lines);

   foreach $stuff (@lines){
        #print("\n$2, $6\n");
        if($stuff =~ /([\w+.]+)(\s+\w+\s+\w+\s+\w+)\s+(\w+)(\s+\w+)(.*)/){
           $start = $1;
           $length = $3;
           $first = $2 . $4;
           $second = $5;
       
           @info = split(' ', "$stuff");


           #If it doesn't have either of these flags, output it over to the trashcan file
           #I think the filtering I've done has cleaned up all unmapped reads.
           if(($info[1] != 0 && $info[1] != 16) || ($info[6] != 0 && $info[6] != 16)){
              print(FACTORY "$stuff\n");
           }
           else{
              #Print out the read name along with the length
              print(OUTPUT "$start $length");
 

              #See if fragment region of the first read is less than the second one.
              if($info[5] < $info[9]){
                 print(OUTPUT "$first$second\n");
              }
              #If not, see if the strand is positive or negative
              elsif($info[5] == $info[9]){

                 #If they're not equal see which one is positive strand
                 if($info[1] != $info[6]){
                    if($info[1] & 0x10){  #If downstream counts, have what's upstream first
                       print(OUTPUT "$second$first\n");
                    }
                    else{
                       print(OUTPUT "$first$second\n");
                    } 
                 }
                 #As the last way to check what pair goes first, see which one
                 #has the lesser position mapped in the sequence.
                 elsif($info[3] < $info[8]){
                    print(OUTPUT "$first$second\n"); 
                 }
                 else{
                    print(OUTPUT "$second$first\n");
                 }
 
              }else{
                 print(OUTPUT "$second$first\n");
              }

           }
        
        }#End this here if statement
   }
   close(OUTPUT);
}

