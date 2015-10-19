#!/usr/bin/perl -w 


# Form replicant files, based on the n -2 characters from the left.


open (LIST, "<finalList.txt") or die "Couldn't access/find \"finalList.txt\"";


while (<LIST>){
  chomp();
  $name = $_;

  s/(\w+)\d\d\..*/$1/;
  $files{$_} .= "$name ";  


}

foreach (keys %files){
   print("File ID: $_ -> $files{$_}\n");

   print("Sorting the file: Replicant.$_.sam\n"); 
                #X and Y chr's need V  to be sorted
   `sort -t ' ' -k4.4n,4.5n -k4.4d,4.5d -k6,6n -k10,10n -k3,3n -k7,7n -k5,5n -k9,9n $files{$_} > Replicant.$_.sam`;
}
