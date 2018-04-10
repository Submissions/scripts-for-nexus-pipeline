#!/bin/bash

worklist_file=$1
data_dir=$2

# Requires: dnanexus-upload-agent/ua
upload_agent=$(which ua)

cat $worklist_file | while read line
do
  sample=`echo "$line" | cut -f1`
  nexus_path=`echo "$line" | cut -f2`

  nexus_data_dir="$nexus_path/working/data"
  nexus_sample_dir="$nexus_data_dir/$sample"

  dx ls $nexus_sample_dir

  if [ $? -eq 0 ]
  then
      header_filename=`echo "$line" | cut -f5`
      header_file_path=$data_dir/$sample/$header_filename

      if [ -f $header_file_path ]
      then
	  echo $upload_agent $header_file_path --do-not-compress -f $nexus_sample_dir
	  $upload_agent $header_file_path --do-not-compress -f $nexus_sample_dir
      else
	  echo "header file missing for sample:" $sample
      fi
  else
      echo "nexus sample dir does not exist for sample:" $sample
  fi
done
