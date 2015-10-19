#!/usr/bin/perl -w

#Rewrite: No use of the combined hindIII file, instead use 
#each file separately. 
if($#ARGV != 2) {
   printf("Arguments: <list of samFiles> <targeted directory> <file name (without the sub-extension)>\n");
   exit;
}

#Binary Search function that finds the closest fragment to a read position
sub findClosestNumber;

#Open the designated list of files to include a fragment region
open (FILELIST, "<$ARGV[0]") or die "Nope, couldn't open your file list\n";
@fileList = <FILELIST>;

$destinedDir = "final$ARGV[1]";

mkdir("$destinedDir");

chomp(@fileList);

for($i = 0; $i <= $#fileList; $i++){
 
   $chr = $fileList[$i];

   $chr =~ s/.*\/?(chr([^\W_]+))(_\w+).*/$1/;
   $letter = $2;
   $splitID = $3;

   #print("My character is $chr, and I have $splitID\n");
   #Access the particular hindIII file every 20 times, since by then, a 
   #bundle of different chromosomes will be accessed!.
   if($i % 20 == 0){
    #   print("$chr, and I have $splitID\n");
       open(FILE2, "<$ARGV[$#ARGV].$letter") or die "Could not bother with $letter\n";
       @hindList = <FILE2>;
          
       foreach $string (@hindList){  
         $string =~ s/.*\:(\d+).*/$1/;
       }
       $reference = \@hindList;
       chomp(@hindList);
   }

   #START of forking
 
   #Parent process. 
   if($pid = fork){
      close(FILE2);
      next;
   }
   elsif(defined $pid){
           #Open the 
          # print(`pwd`);
          # print("$ARGV[1]$fileList[$i]\n"); 
	   open (FILE1, "<$ARGV[1]$fileList[$i]") or die "Could not access $fileList[$i]\n"; 
	   @array2 = <FILE1>;

           
	   chomp(@array2);
	   
	   open(KYRIE, ">$destinedDir/$chr$splitID.important") or die "Incomplete attempt for $chr\n";    

	   #Loop through samfile
	   foreach $line2(@array2){
	      if($line2 =~ /(?|[\w.]+\s){3}(\d+)/){
		 $value1 = $1;      
	      }
	      else{
		 printf("Error with string %s\n", $line2);
		 exit;
	      }

	      if($line2 =~ /SRR.*SRR.*chr\w+\s+(\d+)/){
		 $value2 = $1;    
	      }
	      else{
		 printf("Second Error with string %s\n", $line2);
		 exit;
	      }
	                          
	      $line2 =~ s/(SRR.*chr\w+\s+\d+)\s+\d+\s+(\w+).*SRR\w+\.\w+\.?\d?\s+(\w+\s+\w+\s+\w+).*/$1 $2 $3/;
	      #Loop through hindIII file

	      $frag1 = findClosestNumber($reference, $value1);
	      $frag2 = findClosestNumber($reference, $value2);
	       
	      print(KYRIE "$1 $2 $frag1 " );
	      print(KYRIE "$3 $frag2\n" );
		   
	   }#end this *shorter# for loop

	   close(KYRIE);
	   close(FILE1);
	   close(FILE2);
            
           exit;
	}#end else
        else{
           die "I have no forks! Quick! Buy more at Walmart!\n";
        }
}#end for loop

#END FORK

#Only the parent could be active at this point:
while(wait != -1){
}


#ARGS: Reference to a list of strings to lookup
#      and a value to lookup on the list. 
#
#      Return: Number closest to the second argument

sub findClosestNumber{
   my @localList = @{$_[0]};
   my $low = 0;
   my $high = $#localList;
   my $value = $_[1];
   my $mid = 0;
 
   while($low <= $high){
      $mid = $low + (($high - $low)/2);

      if($localList[$mid] > $_[1]){
         $high = $mid - 1;
      }
      elsif($localList[$mid] < $_[1]){
         $low = $mid + 1;
      }
      else{
         return $localList[$mid];
      }
      $mid = $low + (($high - $low)/2);

   }

   #Now that we're at the closest region, let's make sure to find the best possible number.
   if (abs($localList[$low] - $value) < abs($localList[$low - 1] - $value) && abs($localList[$low] - $value) < abs($localList[$low + 1] - $value)){
      return $localList[$low];
   }
   elsif(abs($localList[$low - 1] - $value) < abs($localList[$low] - $value) && abs($localList[$low - 1] - $value) < abs($localList[$low + 1] - $value)){
      return $localList[$low - 1];
   }
   else{
      return $localList[$low + 1];
   }
}#Finish function!
