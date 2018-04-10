#!/bin/bash

tsv_file=$1
project_name=$2
data_dir=$3
sq_file=$4

cat $tsv_file | while read line
do
  sample_name=`echo "$line" | cut -f1`
  library_name=`echo "$line" | cut -f2`
  run_name=`echo "$line" | cut -f6`

  sample_dir="$data_dir/$sample_name"

  ls $sample_dir > /dev/null

  if [ $? -eq 0 ]
  then
      incomplete_header_file=$(ls $sample_dir/*incomplete.header.sam)
  
      # check if the downloaded file is 0 bytes or not
      if [ -f $incomplete_header_file ] && [ -s $incomplete_header_file ]
      then
	  incorrect_rg_file="$incomplete_header_file".RG

	  header_file=$sample_dir/$sample_name.header.sam

	  rg_file="$header_file".RG
	  pg_file="$header_file".PG

	  cat $incomplete_header_file | grep "@RG" > $incorrect_rg_file
	  cat $incomplete_header_file | grep "@PG" > $pg_file

          # check if rg file is 0 bytes or not
	  if [ -f $incorrect_rg_file ] && [ -s $incorrect_rg_file ]
	  then
	      number_of_rgs=`cat $incorrect_rg_file | wc -l`
	  
	      if [ $number_of_rgs -eq 0 ]
	      then
		  echo "missing rg tags for sample:" $sample_name
		  echo "assuming one @RG for this bam"
		  id="ID:0"
		  number_of_rgs=1
	      elif [ $number_of_rgs -gt 1 ]
	      then
		  echo "multiple rgs exist for sample:" $sample_name
	      fi
	  fi

	  if [ $number_of_rgs -eq 1 ]
	  then
	      id=`cat $incorrect_rg_file | cut -f2`
	      echo -e "@RG\t"$id"\tPL:Illumina\tPU:"$run_name"\tLB:"$library_name"\tDS:"$project_name"\tSM:"$sample_name"\tCN:BCM" > $rg_file
	      cat $sq_file $rg_file $pg_file > $header_file
	  else
	      echo "multiple RG exist for sample:" $sample_name
	  fi
      else
	  echo "extracted header file does not exist:" $incomplete_header_file
      fi
  else
      echo "missing sample dir for sample:" $sample_name
  fi
done
