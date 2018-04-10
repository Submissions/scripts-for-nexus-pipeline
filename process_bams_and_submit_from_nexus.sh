#!/bin/bash

worklist_file=$1

# head -1 $worklist_file | while read line
# tail -n +2 $worklist_file | while read line
cat $worklist_file | while read line
do
  sample=`echo "$line" | cut -f1`
  nexus_path=`echo "$line" | cut -f2`

  nexus_data_dir="$nexus_path/working/data"
  nexus_sample_dir="$nexus_data_dir/$sample"

  dx ls --folders $nexus_sample_dir

  if [ $? -eq 0 ]
  then
      bam_filename=`echo "$line" | cut -f4`
      bam_file_path=$nexus_sample_dir/$bam_filename

      header_filename=`echo "$line" | cut -f5`
      header_file_path=$nexus_sample_dir/$header_filename

      ( dx ls $bam_file_path && dx ls $header_file_path ) > /dev/null

      if [ $? -eq 0 ]
      then
	  output_bam_filename=`echo "$line" | cut -f6`
      
	  aspera_key_file="project-BX7XGq00YKX3X12J59PVZ98Z:file-BX7XJJ00YKXKX2x400670B69"

	  # 600m; server name - gap-upload
	  # app_id="project-BX7XGq00YKX3X12J59PVZ98Z:applet-BXVBVz80x83xZvQkj1Qbxx7v"

	  # 200m; server name - gap-upload
	  # app_id="project-BX7XGq00YKX3X12J59PVZ98Z:applet-BXbFGg80yGGQJ5kxp1zB0xy5"

          # set transfer speed; server name - gap-submit
          app_id="project-BX7XGq00YKX3X12J59PVZ98Z:applet-BbXFBb00KP03F3pJ1VF01kQF"


	  echo "dx run $app_id -i input_bam_file=$bam_file_path -i input_header_file=$header_file_path -i output_bam_filename=$output_bam_filename -i aspera_key_file=$aspera_key_file -i transfer_speed=200 --destination=$nexus_sample_dir --brief"
	  dx run $app_id -i input_bam_file=$bam_file_path -i input_header_file=$header_file_path -i output_bam_filename=$output_bam_filename -i aspera_key_file=$aspera_key_file -i transfer_speed=200 --destination=$nexus_sample_dir --brief
      else
	  echo "bam/header do not exist for sample:" $sample
      fi
  else
      echo "nexus sample dir does not exist for sample:" $sample
  fi
done
