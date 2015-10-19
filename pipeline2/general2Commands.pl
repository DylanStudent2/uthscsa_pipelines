#!/usr/bin/perl -w 

#Script for creating pbs Scripts for submission!
#This script will first be used for the SRA toolkit, 
#then it will be used for the BWA toolkit, with output files specified

if($#ARGV < 2 ){
   printf("ARGUMENTS: <command> [directory(s)] <output's extension> [arguments] <output directory> \n");
   exit;
}
my $args = " ";
my $counter = 0;
for(my $i = 1; $i < $#ARGV; $i++){

   #If argument is a directory.
   if($ARGV[$i] =~ /\/$/){
      my @ref = split('\n',`ls $ARGV[$i]`);
            
      for(my $j = 0; $j <= $#ref; $j++){
         $array[$counter][$j] = $ARGV[$i] . $ref[$j];
      }
      $counter++;
   }#If the argument is extension, copy it.
   elsif($ARGV[$i] =~ /^\./){
      $extension = $ARGV[$i];
   }
   else{
      $args .= "$ARGV[$i] ";
   }
}

$counter = 1;

if (-d "pbsScripts"){
   `rm -r \"pbsScripts\"`;
}

mkdir("pbsScripts");

if(-d "$ARGV[$#ARGV]"){
   `rm -r \"$ARGV[$#ARGV]\"`;
}

mkdir ("$ARGV[$#ARGV]");

#Create the pbsScripts!!!
for( $i = 0; $i <= $#{$array[0]}; $i++){
      $destination = $array[0][$i];
      $destination =~ s/.*\/(\w+)\..*/$1$extension/;      
      
      for($j = 0; $j <= $#array; $j++){
         $item .= " $array[$j][$i]";
      } 
      open(FILE, ">pbsScripts/$counter.pbs.Script") or die "Cannot open $counter.pbs.Script\n";
      
      print(FILE "#PBS -l nodes=1:ppn=1
		  #PBS -l walltime=144:00:00
                  #PBS -l pmem=4gb
                  cd \$PBS_O_WORKDIR

                `$ARGV[0] $args $item > $ARGV[$#ARGV]$destination`"); 

      $item = "";
      $counter++;
      close(FILE);
}

