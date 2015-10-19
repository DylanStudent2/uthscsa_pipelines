#!/bin/bash
checkMakeDirectory(){
	echo -e "checking directory: $1"
	if [ ! -e "$1" ]; then
		echo -e "\tmakedir $1"
		mkdir -p "$1"
	fi
}

biasCmd="/home/sodermand/Hi-Corrector1.2/bin/ic"
normCmd="/home/sodermand/Hi-Corrector1.2/bin/export_norm_data"

output_dir="$PWD/output_ic" # output directory
checkMakeDirectory $output_dir

has_header_line=0  # input file doesn't have header line
has_header_column=0 # input file doesn't have header column

input_mat_file=$1 #input contact matrix file, each line is a row, numbers are separated by TAB charp
input_mat=$input_mat_file".tmp" # <input raw matrix file>
sed 's/,/\t/g' $input_mat_file > $input_mat
total_rows=$(echo `wc -l < $input_mat_file`); # total number of rows in the input contact matrix

# input parameters for bias factor
max_iter=20  # total number of iterations that are needed to run in the ic algorithm
bias_factor_file="$input_mat_file.bias_factors" # output file consists of a vector of bias factors
log_file="$output_dir/contact.matrix.log" # log file recording the verbose console output of the ic command

# run the bias factor command
#echo "$biasCmd $input_mat $total_rows $max_iter $has_header_line $has_header_column $bias_factor_file > $log_file"
$biasCmd $input_mat $total_rows $max_iter $has_header_line $has_header_column $bias_factor_file > $log_file


# input parameters for export_norm
total_mem="10" # memory used for loading data (in MegaBytes)
row_sum_after_norm=100 # <fixed row sum after normalization>
norm_file="$input_mat_file.norm" # output file consists of a vector of bias factors

# run the export_norm command
#echo "$normCmd $input_mat $total_rows $has_header_line $has_header_column $total_mem $bias_factor_file $row_sum_after_norm $norm_file"
$normCmd $input_mat $total_rows $has_header_line $has_header_column $total_mem $bias_factor_file $row_sum_after_norm $norm_file

rm $input_mat



echo "normalizing by HiCorrector done"
