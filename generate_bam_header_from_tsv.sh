#!/bin/bash

tsv_file=$1
data_dir=$2
project_name=$3
platform=$4

cat $tsv_file | while read line
do
  sample=`echo "$line" | cut -f1`
  sample_dir="$data_dir/$sample"

  if [ -d $sample_dir ]
  then
      echo "$sample_dir exists.."
  else
      echo mkdir $sample_dir
  fi

  library=`echo "$line" | cut -f2`
  run=`echo "$line" | cut -f6`
  center="BCM"

done