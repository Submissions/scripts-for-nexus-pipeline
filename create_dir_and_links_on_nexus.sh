#!/bin/bash

# need to be logged into dna nexus
# need to be in the correct project

worklist_file=$1

cat $worklist_file | while read line
do
  sample_name=`echo "$line" | cut -f1`

  nexus_path=`echo "$line" | cut -f2`
  nexus_data_dir="$nexus_path/working/data"

  dx ls $nexus_data_dir > /dev/null

  if [ $? -eq 0 ]
  then
      sample_dir="$nexus_data_dir/$sample_name"
      bam_file_id=`echo "$line" | cut -f3`

      echo "dx mkdir -p $sample_dir"
      dx mkdir -p $sample_dir
      
      echo "dx cp $bam_file_id $sample_dir/"
      dx cp $bam_file_id $sample_dir/
  else
      echo "nexus dir doesn't exist:" $nexus_data_dir
      exit 1
  fi
done
