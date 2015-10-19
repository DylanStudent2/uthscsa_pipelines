#!/usr/bin/awk -f

#ARGUMENTS: <list of files to process, one file per line> ,
#           <name of executable>
#           <name of reference genome for input>

BEGIN{counter =0;fileNum=0; newFile  = 1}
{if(ARGIND == 2){
   exit
}}
{counter ++}

{if(newFile != fileNum){
	fileNum++
        printf("#PBS -l nodes=1:ppn=1\n#PBS -l walltime=72:00:00\n#PBS -l pmem=4gb\n\ncd $PBS_O_WORKDIR\n\n./%s",ARGV[2]) > "pbsGetDoneQuicker"fileNum".script"
}}

{if(counter % 5 == 0){ 
 	newFile++
 	{printf(" JinFiles/%s ", $0) >> "pbsGetDoneQuicker"fileNum".script"} 
        {printf( ARGV[3]" > results/result%s.txt\n",fileNum) >> "pbsGetDoneQuicker"fileNum".script"}
                               
}
 else
	{printf(" JinFiles/%s ", $0) >> "pbsGetDoneQuicker"fileNum".script"}
}

    #Don't want to be redundant
END{if(counter % 5 != 0){printf( ARGV[3]" > results/result%s.txt\n",fileNum) >> "pbsGetDoneQuicker"fileNum".script"}}
