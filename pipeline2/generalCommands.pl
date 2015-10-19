#!/usr/bin/perl -w 

#Script for creating pbs Scripts for submission!
#This script will first be used for the SRA toolkit, 
#then it will be modified to produce specified output for bwa toolkit.
#If you wish to specify your own directory, just use "." but 
#be aware that all files with a matching extension will be grabbed.

if($#ARGV < 2 ){
   printf("ARGUMENTS: <command> <directory> <extension> [arguments] \n");
   exit;
}


@array = `find $ARGV[1] | grep -P "(\\.)?$ARGV[2]\$" `;
chomp(@array);


for($i = 3; $i <= $#ARGV; $i++){
   $args .= "$ARGV[$i] ";
}


if (-d "pbsScripts"){
   `rm -r \"pbsScripts\"`;
}
mkdir("pbsScripts");

$counter = 1;
#Create the pbsScripts!!!
foreach $item (@array){
      

      open(FILE, ">pbsScripts/$counter.pbs.Script") or die "Cannot open $counter.pbs.Script\n";
      
      print(FILE "#PBS -l nodes=1:ppn=1
		  #PBS -l walltime=144:00:00
                  #PBS -l pmem=4gb
                  cd \$PBS_O_WORKDIR

                `$ARGV[0] $args $item`"); 

      $counter++;
      close(FILE);
}

