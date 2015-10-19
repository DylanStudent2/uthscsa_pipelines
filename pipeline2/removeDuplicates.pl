#!/usr/bin/perl -w 
#Let's clean up any instance of a duplicate from our file!

if($#ARGV != 1){
   die "Argument: <Directory location to manage> <list of the files you wish to process> \n";
}
elsif($ARGV[0] !~ /\/$/){
   die "Add a \"/\" character at the end of your second argument please\n";
}

open(FILE, "<$ARGV[1]") or die "Couldn't find $ARGV[1]\n";

my ($prev1, $prev2, $prev3, $prev4) = (0,0,0,0);
mkdir("$ARGV[0]filtered");
mkdir("$ARGV[0]duplicates");

#Have this script remove reads with the same fragmentations as well.
mkdir("$ARGV[0]sameFrags");
   
foreach $string (<FILE>){
   chomp($string);

   #OPEN A FORK  

   if($pid = fork){
      next;
   }
   elsif(defined $pid){
   open(TARGET, "<$ARGV[0]$string") or die "Couldn't find a $string\n";

   $string =~ s/^(\w+\.\w+).*/$1/;
   open(TRASH, ">$ARGV[0]duplicates/trash$string.txt");
   open(OUTPUT, ">$ARGV[0]filtered/$string.final"); 
   open(ALSOTRASH, ">$ARGV[0]sameFrags/$string.txt"); 
   
 
   $count= 0; #Line number from the original file (used for checking the trash files).
   while  (<TARGET>){
   
                #Capture the length
   if(/^\S+\s(\w+)\s/){
      $thing = $1;
   }
   @values = split(/M|I|S/, $1);
   foreach $cigar (@values){
      $cigar =~ s/.*[A-Z](\d+)$/$1/;
      if(/[A-Za-z]$/){
         next;
      }
      $value += $cigar;
   }
   $count++;                                                  #A2
 #                 A1      length  strand  chr  pos.   frag   strand chr   pos.  frag         
      if(/[\w.]+\s\w+\s+(\w+)\s\w+\s(\w+)\s(\w+)\s(\w+)\s\w+\s(\w+)\s(\w+)/){
          $value1 = $2;
          $value2 = $5;          
  
          if($1 == 16){
             $value1 += $value;
          }
          if($4 ==16){
             $value2 += $value;
          } 
          #Test for a duplicate : when the line has the same columns as the previous line
          #With the positions ($2 and $4) being considered duplicate if the distance is within 4 bp
          if($1 == $prev1 && abs($value1 - $prev2) <= 4 && $4 == $prev3 && abs($value2 - $prev4) <= 4){
             print(TRASH "$count $_"); 
          }
          elsif($3 eq $6){
             print(ALSOTRASH "$count $_");
          }
          else{
             print(OUTPUT "$_");
              ($prev1, $prev2, $prev3, $prev4) = ($1, $value1, $4, $value2); 
          }  
      }

   }
      exit;
   }
   else{
      die "Fork Error!\n";
   }
   #END FORK
   #close(TRASH);
}

if($pid){
   while(wait != -1){

   }
}

