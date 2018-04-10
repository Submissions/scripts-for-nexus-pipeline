#!/bin/bash

worklist_file=$1

cat $worklist_file | while read line
do
  sample=`echo "$line" | cut -f1`
  nexus_path=`echo "$line" | cut -f2`
  submission_bam_filename=`echo "$line" | cut -f6`

  nexus_data_dir="$nexus_path/working/data"
  nexus_sample_dir="$nexus_data_dir/$sample"
  submission_bam_path="$nexus_sample_dir/$submission_bam_filename"
  md5_file_path="$nexus_sample_dir/$submission_bam_filename".md5

  dx ls $nexus_sample_dir > /dev/null

  if [ $? -eq 0 ]
  then
      dx ls $md5_file_path > /dev/null
      
      if [ $? -eq 0 ]
      then
	  echo dx download $md5_file_path -o data/$sample/ --no-progress
	  dx download $md5_file_path -o data/$sample/ --no-progress
      else
	  echo "md5file missing for sample:" $sample
      fi
  else
      echo "sample dir missing for sample:" $sample
  fi
done