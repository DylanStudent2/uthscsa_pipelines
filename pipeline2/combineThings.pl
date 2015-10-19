#!/usr/bin/perl

#This program has been further generalized within part2SRR directory!

# This is the definitive combination function. Takes in list 
# instead of a sorting argument. The list can be a product of the sorting argument. 
# Please read the info page on sort to get a firm grasp of how to sort file 
# listss in whatever way you so desire. For example: having the argument
# "sort -k1.4n,1.5n <list>" sorts the lists based on the fourth and fifth 
#  characters within the first column ("." specifies position in column, ","
#  specifies the column itself) the sorting priority is from left to right,
#  so the "4th" character has precedence over the "5th". the "n" attached 
#  at the ends specify that it has to be sorted numerically. This sort 
#  works for things like "chr4.txt", "chr50.txt", and so on, and since 
#  the "n" numeric sort is attached, "chr4.txt" won't follow after "chr50.txt"
#  since the "." character has a higher value in the ascii table than "0" in 
#  chr50.txt.  
#
# 



if($#ARGV != 2){
   die "Arguments: <name of directory for input> <listOfFiles to be combined together/ extension of file names> <\"cat\" or \"paste\" argument>\n";
}
elsif($ARGV[0] !~ /\/$/){
   die "Argh! Put a \"/\" character at the end of your directory argument!\n";
}
elsif($ARGV[$#ARGV] !~ /[Cc](at)?$|[Pp](aste)?$/){
   die "Please specify whether you wanna paste or cat(enate). Use either the full names or single letter abbreviations\n";
}
elsif($ARGV[1] =~ /^\w$/){
   die "Please include a \".\" at the beginning of your extension!\n";
}


#Testing cases can afford to be lazy once the main case (above) already prevents any other possibility from leaking through. 
if($ARGV[$#ARGV] =~ /[Pp]/){
  $command = "paste"; 
  if (-d "samPasted"){
   `rm -r samPasted`;
  }
  mkdir "samPasted";

}else{
  $command = "cat";
}

              #Has to be explicit, else this could pass off as a list of files!
if($ARGV[1] !~ /^\.\w+$/){

   open(LIST, "<$ARGV[1]") or die "Couldn't find $ARGV[1]\n";
   @list = <LIST>;
}
else{
   @list = `find $ARGV[0] | grep -P ".*$ARGV[1]" | sort`;
}
   chomp(@list);

#Contains the files.
if($command eq "cat"){
   foreach $argument (@list){
      $string .= "$ARGV[0]$argument ";
   }

   $ARGV[0] =~ s/(\w+).*/$1/;

   print(`$command $string`);
}
#Pasting
else{
   for($i = 1; $i <= $#list + 1; $i++){
      
      $string .= "$list[$i-1] ";
      if($i % 2 == 0){
         #print("$list[$i -1]\n");
         $list[$i -1] =~ s/^\w+\/([^\W_]+)\w+($ARGV[1])/$1$2/;
         `$command $string > pastedRepo/$list[$i-1]\n`;
         $string = "";
         
      }
   }
}
