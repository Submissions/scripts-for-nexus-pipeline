#!/bin/bash

tsv_file="$1"               # chs_wgs_f1_b100_20141218.final.tsv
biosample_file="$2"         # chs_wgs_f1_b100_20141218.biosamples
data_dir="$3"               # data/
extension="$4"              # "Illumina"

date=`date +%Y%m%d`

cat $tsv_file | while read line
do
    sample=`echo "$line" | cut -f1`
    sample_dir=`ls -d $data_dir/$sample`

    metadata_dirname="bcm-sra-$sample"_"$extension"_"$date"
    metadata_dir=$sample_dir/$metadata_dirname

    if [[ -a $metadata_dir ]]
    then
	echo "$metadata_dir exists"
    else
	echo mkdir $metadata_dir
	mkdir $metadata_dir
    fi

    scripts_home="/groups/submissions/software/noarch/apps/bcm-hgsc-nexgen-submission-pipeline/4-package-metadata"

    # experiment xml
    echo python $scripts_home/generate_experiment_xml.py $sample $tsv_file $biosample_file $metadata_dir
    python $scripts_home/generate_experiment_xml.py $sample $tsv_file $biosample_file $metadata_dir
    # run xml
    echo python $scripts_home/generate_run_xml.py $sample_dir $metadata_dir
    python $scripts_home/generate_run_xml.py $sample_dir $metadata_dir
    mv $metadata_dir/runs.yaml $sample_dir
done
