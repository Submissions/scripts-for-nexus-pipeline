#!/bin/bash

tsv_file=$1
nexus_dir=$2
extension=$3

cat $tsv_file | while read line
do
  sample_name=`echo "$line" | cut -f1`
  bam_file_id=`echo "$line" | cut -f5 | cut -d"=" -f1`
  bam_file_name=`echo "$line" | cut -f5 | cut -d"=" -f2`

  final_header_file_name="$sample_name.header.sam"

  output_bam_file_name="$sample_name"_"$extension"_Illumina.bam
  
  echo -e $sample_name"\t"$nexus_dir"\t"$bam_file_id"\t"$bam_file_name"\t"$final_header_file_name"\t"$output_bam_file_name
done