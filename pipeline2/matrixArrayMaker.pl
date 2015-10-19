#!/usr/bin/perl -w 

use POSIX;

if($ARGV[$#ARGV] !~ /^\d+$/ || $#ARGV == 0){
   die "Please specify the tolerance of the matrices, the arguments should be:
       <path> [...]  <round to nearest number>\n";
}

@fileNames = `find $ARGV[0] | grep -P \".final\$\"`;

chomp (@fileNames);
foreach $name (@fileNames){
   open (FILE, "<", "$name") or die "Can't find file \"$name\".\n";

   while(<FILE>){
      #Capture line
      #                 x                              y 
      #         #1      2                         3        4        
      if(/.*chr(\w+)\s+(\d+)\s+(?|[+-]|\d+).*chr(\w+)\s+(\d+)/){
         if(not($1 eq $3)){
            next;
         }
         else{
            $valueRow = ceil($2 / $ARGV[$#ARGV]);
            $valueCol = ceil($4 / $ARGV[$#ARGV]);
            $data{"$1"}[$valueRow][$valueCol]++; 
         }
      }
   }
}
close(FILE);

   #This will be a file containing a list of filenames that have been created. This will be useful in my rscript 
   #open(FILE, ">>", "Filenames.txt") or die "Failed to create new file: Filenames.txt"; 
   #Counters for plotting

if(-d "matrices"){
   `rm -r matrices`;
}

mkdir("matrices");
foreach $matrix (keys %data){

   open(FILEOUT, ">", "matrices/Chromosome$matrix.txt") or die "Failed to create new file \"Chromosome$matrix.txt\"";

  # print(FILE "Chromosome$matrix.txt,");

      #Set up the columns to print out
      #------------------UNCOMMENT OUT IF YOU WISH TO HAVE HEADERS----------
=pod  print(FILEOUT "1");
 #  for $col (2 .. $#{$data{$matrix}}){
 #     printf(FILEOUT ",%d",$col);
 #  }
 #  print(FILEOUT "\n");     #The keys are hash references (they point to another hash)
                          #So the "%" character has to be slapped at the beginning
=cut

   for $posY (1 .. $#{$data{$matrix} }){
                    #This key is a scalar reference, so the derefenced hash needs to have a 
                    #"$" character appended at the beginning

      #print(FILEOUT "$posY");

      #These are square matrices, I won't be concerned with the length
      for $posX (1 .. $#{$data{$matrix} }){

      #If a value is defined, print its number, else print 0
         if(defined $data{$matrix}[$posY][$posX] ){
            printf(FILEOUT "%d,", $data{$matrix}[$posY][$posX] );
         }
         else{
            printf(FILEOUT "0,");
         }
      }
      printf(FILEOUT "\n");
   }
   close(FILEOUT);
}#end last foreach loop

close(FILE);
#@info = stat("Filenames.txt"); 
#Delete trailing comma in the file that contains the names of all the matrixes produced. 
#truncate("Filenames.txt", $info[7] - 1);
