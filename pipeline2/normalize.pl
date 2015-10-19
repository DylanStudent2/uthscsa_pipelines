#!/usr/bin/perl -w 



#Have the scripts made!



				       #Removed |[XY]
@list = `ls $ARGV[0] | grep -P "Chromosome(\\d+|[XY])\\.txt\$"`;

chomp(@list);

foreach $item (@list){


       print("Performing normalization on $item\n");
       `./hicorrector.bash $ARGV[0]$item`;

       if($item =~ /Chromosome(\w+)/){
          
          `./topDom.bash $ARGV[0]$item chr$1 $ARGV[1]`; 
       }
} 
