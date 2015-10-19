#!/bin/bash
#-l nodes=n4:ppn=2,walltime=72:00:00

file=$1
chrom=$2;
bin=$3

extendBin=15

dir=$(dirname $file)
source /etc/profile.d/modules.sh
module load R/R-3.0.2

rfile=/backup/sodermand/mergedFiles/runTopDom.r

awk -v chr=$chrom -v b=$bin 'BEGIN{OFS="\t"}{print chr,(NR-1)*b,NR*b,$0}' $file.norm > $file.norm.bed
R --vanilla --slave --args $file.norm.bed $extendBin $file.binSignal $file.domain < $rfile



echo "calling domain by TopDom done"
