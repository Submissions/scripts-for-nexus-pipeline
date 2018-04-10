#!/bin/bash

# needs to be run from working OR ARIC/ARIC-B200-SUB/BAM-I-WXS dir

worklist_file=$1

num_of_samples=`cat $worklist_file | wc -l`
echo "number of samples in worklist:" $num_of_samples 

cat $worklist_file | while read line
do 
  sample=`echo "$line" | cut -f1`
  nexus_path=`echo "$line" | cut -f2`
  submission_bam_filename=`echo "$line" | cut -f6`

  nexus_data_dir="$nexus_path/working/data"
  nexus_sample_dir="$nexus_data_dir/$sample"
  nexus_submitted_dir="$nexus_path/submitted"

  bam_file_path="$nexus_sample_dir/$submission_bam_filename"

  ( dx ls $nexus_sample_dir && dx ls $nexus_submitted_dir ) > /dev/null

  if [ $? -eq 0 ]
  then
      aspera_log_file="$nexus_sample_dir/$submission_bam_filename".aspera.log

      dx ls $aspera_log_file > /dev/null

      if [ $? -eq 0 ]
      then
	  bams_completed=`dx cat $aspera_log_file | grep -v -e uploaded -v -e started -v -e finished | grep -c Completed`
	
	  if [ $bams_completed -eq 1 ]
 	  then
 	      echo "bam upload success:" $bam_file_path
 	      echo "dx mv $nexus_sample_dir $nexus_submitted_dir/"
	      dx mv $nexus_sample_dir $nexus_submitted_dir/
	      echo "mv data/$sample ../ready"
	      mv data/$sample ../ready
 	  else
 	      echo "bam upload failed:" $bam_file_path
 	  fi
      else
 	  echo "bam not queued up for upload:" $bam_file_path
      fi
  fi
done
