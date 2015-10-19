#!/usr/bin/perl -w

# What the task is at hand:
#
# Update the TSS (Transcription Starting Sites) on tables of interacting loci
# from a data file from online. Depending on whether the "strand" is 
# + or -, the TSS will be the left or right column respectfully. 
# Furthermore, the loci pairs  are independent from eachother
# and so I'll search for the closest TSS for each individually. 
# Basically, each row will result in two searches throughout the entire 
# online file. 
# 

use POSIX;

open (FILE, "<$ARGV[$#ARGV]") or die "Cannot find arg2 file: $ARGV[$#ARGV]"; 
@segments = <FILE>;

for( $i = 0; $i < $#ARGV; $i++){

   open(JINFILE, "<$ARGV[$i]") or die "Cannot find file: $ARGV[$i]";

foreach $line (<JINFILE>){

   if($line =~ /(.*)\s+(chr\w+)\s+(\d+)\s+(\d+)\s+(chr\w+)\s+(\d+)\s+(\d+)\s*/){

      $distance1 = 0x7FFFFFFF;
      $distance2 = 0x7FFFFFFF;

      $probability = $1;

      $chrome1  = $2;
      $loc1Strt = $3;
      $loc1End  = $4;

      $chrome2  = $5;
      $loc2Strt = $6;
      $loc2End  = $7;
      $type = "";

      foreach $segment (@segments){
                         # The freq id  chr       $2       $3      $4      $5
         if($segment =~ /(\w+_?\w+)\s+$chrome1\s+([-+])\s+(\d+)\s+(\d+)\s+(\w+).*/){

            if($2 eq "+"){
               $TSS = $3;

	       #Find out which loci boundary is closest to the Transcription Start Site
	       $value1 = $TSS - $loc1Strt;
               $value2 = $TSS - $loc1End;
               #Find out if the middle loci position is closest
               $value3 = $TSS - ceil((($loc1Strt + $loc1End)/2));
            }
            else{
               $TSS = $4;

	       $value1 = $loc1Strt - $TSS;
               $value2 = $loc1End  - $TSS;
               $value3 = ceil((($loc1Strt + $loc1End)/2)) - $TSS;
            }

            #printf("$TSS - $loc1Strt = $value1\n$TSS - $loc1End = $value2\n$TSS - %d = $value3\n", ceil((($loc1Strt + $loc1End)/2)));
            #
            if(abs($value1) >= abs($value2) && abs($value3) >= abs($value2)){
               $answer = $value2;
            }
            elsif(abs($value2) >= abs($value1) && abs($value3) >= abs($value1)){
               $answer = $value1;
            }
            else{
               $answer = $value3;
            }

            if(abs($answer) < $distance1){
               $distance1   = abs($answer);
            
               $finalDist    = $answer;
               $freqID       = $1;
               $strand       = $2; 
               $clGeneOne    = $3;
               $otherEnd     = $4;
               $geneName1    = $5;
	       if($answer < 0){
	          $label = "DownStream";
	       }
	       else{
	          $label = "UpStream";
	       }
            }
         }#End of if case for the first chromosome
      }#End loop through FILE
    
         if($finalDist >= -1000 && $finalDist <= 5000){
            $type = "P";
	 }
         elsif (abs($finalDist) <= 10000){
	    $type = "N";
         }
         elsif (abs($finalDist) <= 500000){
	    $type = "D";
         }
         else{
            $type = "F";
         }
 
      printf("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,",$probability,$chrome1,$loc1Strt,$loc1End,$finalDist,$strand,$label,$clGeneOne,$otherEnd,$geneName1,$freqID);
      #PRINT DATA HERE!!!!

      #Begin second loop!
      foreach $segment (@segments){
                         # The freq id  chr       $2       $3      $4      $5
         if($segment =~ /(\w+_?\w+)\s+$chrome2\s+([-+])\s+(\d+)\s+(\d+)\s+(\w+).*/){

	    if($2 eq "+"){
               $TSS = $3;

	       #Find out which loci boundary is closest to the Transcription Start Site
	       $value1 = $TSS - $loc2Strt;
               $value2 = $TSS - $loc2End;
               #Find out if the middle loci position is closest
               $value3 = $TSS - ceil((($loc2Strt + $loc2End)/2));
            }
            else{
               $TSS = $4;

	       $value1 = $loc2Strt - $TSS;
               $value2 = $loc2End  - $TSS;
               $value3 = ceil((($loc2Strt + $loc2End)/2)) - $TSS;
            }

            #printf("$TSS - $loc1Strt = $value1\n$TSS - $loc1End = $value2\n$TSS - %d = $value3\n", ceil((($loc1Strt + $loc1End)/2)));
            
	    if(abs($value1) >= abs($value2) && abs($value3) >= abs($value2)){
               $answer = $value2;
            }
            elsif(abs($value2) >= abs($value1) && abs($value3) >= abs($value1)){
               $answer = $value1;
            }
            else{
               $answer = $value3;
            }

            if(abs($answer) < $distance2){
               $distance2   = abs($answer);
            
               $finalDist    = $answer;
               $freqID       = $1;
               $strand       = $2; 
               $clGeneOne    = $3;
               $otherEnd     = $4;
               $geneName2    = $5;
               if($answer < 0){
	          $label = "DownStream";
	       }
	       else{
	          $label = "UpStream";
	       }
            }
         }#End of if case for the first chromosome
      }#End loop through FILE
    
         if($finalDist >= -1000 && $finalDist <= 5000){
            substr($type,0,0) = "P";
	 }
         elsif (abs($finalDist) <= 10000){
	    substr($type,1,0) = "N";
         }
         elsif (abs($finalDist) <= 500000){
	    substr($type,1,0) = "D";
         }
         else{
            substr($type,1,0) = "F";
         }

      if($type !~ /P/){
	 $type = "O:O";
      }
      elsif($geneName2 eq $geneName1){
	 substr($type,2,0) = '1';
      }
      else{
	 substr($type,2,0) = '2';
      }
 
      printf("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",$chrome2,$loc2Strt,$loc2End,$finalDist,$strand,$label,$clGeneOne,$otherEnd,$geneName2,$freqID,$type);
      #PRINT DATA HERE!!!!
   }#End regular expression if case
}#End loop through JINFILE

   close(JINFILE);
}
