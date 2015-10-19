#!/usr/bin/perl -w 
#
#
#  This script will gather all the pieces of replicant files 
#  and combine them all together.

#
#
=pod
Chromosome
-k3.4n,3.5n
                frags          strand        position
`sort -t ' ' -k4.4n,4.5n -k6,6n -k10,10n -k3,3n -k7,7n -k5,5n -k9,9n 2.replicate/chr14.txt >
2RepScripts/chr14.txt.result`
=cut

open (DIR, "<dirList.txt") or die "Couldn't access the directory list\n";

@dir = <DIR>;
chomp(@dir);

#All directories contain the same named files, just ls an arbitrary one.

foreach $repo (@dir){
   `ls $repo | sort -k1.4n,1.5n > fileList.txt`;


   $destination = $repo;
   $destination =~ s/final(\w+)\//$1/;
   print("Merging files to form:  $destination.sam\n");

   `./../combineThings.pl $repo fileList.txt cat > $destination.sam`;

}


