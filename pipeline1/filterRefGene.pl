#!/usr/bin/perl -w 
#



#ARGUMENTS: <ref gene file>




open (FILE, "<$ARGV[0]") or die "Couldn't find $ARGV[0]\n";
open (NEW, ">referenceGene.txt");
open (TRASH, ">filteredOutGenes.txt");

while (<FILE>){
   #Any sort of LINC or MIR gene is not needed
   if(/LINC|MIR/ || /unk\s+unk/){
      print(TRASH "$_");
      next;
   }
   else{
      chomp();
      $hash{$_}++;
   }

   if($hash{$_} == 1){
      print(NEW "$_\n");
   }
   
}

`rm $ARGV[0]`;
