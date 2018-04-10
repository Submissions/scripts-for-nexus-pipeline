#!/bin/bash

tsv_file=$1
data_dir=$2

wxs_headers_dir="/groups/submissions/projects/charges/dna-nexus-downloads/wes_headers"

cat $tsv_file | while read line
do
    sample=`echo "$line" | cut -f1`
    sample_dir=$data_dir/$sample

    barcode=`echo "$line" | cut -f4`
    number_of_bam_headers=`ls $wxs_headers_dir/$barcode*header | wc -l`
  
    incomplete_header_path=$sample_dir/$sample".incomplete.header.sam"

    if [ $number_of_bam_headers -eq 1 ]
    then
	bam_header=`ls $wxs_headers_dir/$barcode*header`
	echo "extracting rg and pg lines from:" $bam_header
	grep -e "@RG" -e "@PG" $bam_header >> $incomplete_header_path
    elif [ $number_of_bam_headers -eq 0 ]
    then
	echo "no bam header exists for:" $sample
    else
	echo "more than one bam header exists for:" $sample
    fi
done
