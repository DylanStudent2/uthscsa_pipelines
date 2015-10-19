#!/usr/bin/perl -w 

#ARGUMENTS:  <directory of pbsScripts>  NOTE: the scripts must have 
#                                             a ".Script" or ".script" appended
#                                              at the end
#                                             for this perlscript to work.

if(not exists($ARGV[0]) || $ARGV[0] !~ /\/$/){
   printf("Put in argument <directory of files>, with \"/\" character at end\n");
   exit;
}

@list = `find $ARGV[0]`;

foreach $item (@list){
      
        chomp($item);

        if($item =~ /\.[Ss]cript$/){  
           print("Submitted : $item\n");
	   `qsub $item`; 
        }
        
}
