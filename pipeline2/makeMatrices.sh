#!/bin/bash

echo "Enter the bin limit:"

read bin

echo "`./matrixArrayMaker.pl replicants/filtered/ $bin`" 

sed 's/,$//' matrices/Chromosome*.txt -i


#I recieve an error when running this: 

#Error in if (x[cp$cp[i]] >= x[cp$cp[i] - 1] && x[cp$cp[i]] >= x[cp$cp[i] +  : 
#  missing value where TRUE/FALSE needed
#  Calls: TopDom -> Detect.Local.Extreme
#
# Though the domain and normalized files are produced anyways.

echo "Normalizing the matrices, ignore error messages"

echo "`./normalize.pl matrices/ $bin`"
