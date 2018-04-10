# create a project on dna-nexus by logging in through their website
submissions_test_20141030

# login using the command line
dx login

# asks you to select a project on dna-nexus
Available projects (CONTRIBUTE or higher):
0) submissions_test_20141030 (ADMINISTER)
1) submissions_test_20140918 (ADMINISTER)

# select 1)
# create test-bam dir under that project
dx mkdir test-bam
dx cd test-bam

# upload a bam file to test-bam/
ua path/to/sample-1.bam --do-not-compress 
# => DID NOT upload to test-bam/ went into the project dir despite the cd

ua path/to/sample-1.bam --do-not-compress -f /test-bam
# => DID upload to test-bam/ ; all dirs in the project dir start with '/' as root

# to change to a different project
dx select 

# asks you to select a project on dna-nexus
Available projects (CONTRIBUTE or higher):
0) submissions_test_20141030 (ADMINISTER)
1) submissions_test_20140918 (ADMINISTER)

# OR

# you can specify the project name
dx select submissions_test_20141030

# will try to ls the sample-1.bam uploaded to a different project
dx ls submissions_test_20140918:/test-bam

# remove recently copied file just to test the rm command
dx rm /test-bam/sample-1.bam

# copy it again since we need it
dx cp submissions_test_20140918:/test-bam/sample-1.bam submissions_test_20141030:/test-bam

## possible commands for the pipeline
# create dir structure and copy the bam for submission

# do not need an app to do this
# dx-run-app-locally generate-dir-structure/ -iworklist=submission_20141210.worklist

cat submission_20141210.worklist | cut -f1,2 | while read line; do nexus_path=`echo "$line" | cut -f1`; source_bam=`echo "$line" | cut -f2`; dx mkdir -p $nexus_path; dx cp $source_bam $nexus_path/; done

# extract rg and pg lines from the bams at nexus
cat submission_20141210.worklist | while read line; do nexus_path=`echo "$line" | cut -f2`; bam_file=`echo "$line" | cut -f3`; bam_file_path=$nexus_path/$bam_file; sample_name=`echo "$line" | cut -f1`; output_rg_pg_file=`echo "$line" | cut -f4`; echo dx run extract-rg-pg-from-bam -i input_bam_file=$bam_file_path -i output_rg_pg_filename=$output_rg_pg_file; dx run extract-rg-pg-from-bam -i input_bam_file=$bam_file_path -i output_rg_pg_filename=$output_rg_pg_file --destination=$nexus_path --brief; done

# download rg and pg lines from the bams at nexus
cd project-1/batch-1/working/data
cat ../../../../submission_20141210.worklist | while read line; do sample_name=`echo "$line" | cut -f1`; nexus_path=`echo "$line" | cut -f2`; incomplete_header_file=`echo "$line" | cut -f4`; incomplete_header_file_path=$nexus_path/$incomplete_header_file; echo dx download $incomplete_header_file_path -o $sample_name/ --no-progress; dx download $incomplete_header_file_path -o $sample_name/ --no-progress; done

# generate bam header locally
cd project-1/batch-1/working
sh generate_bam_header.sh test.final.tsv "CHARGE-S ARIC" data /users/pipeline/p-submit/svn-installed/resource/header/GRCh37-lite/SQHeader.txt

# upload bam headers to nexus
cat ../../../submission_20141210.worklist | while read line; do sample_name=`echo "$line" | cut -f1`; nexus_path=`echo "$line" | cut -f2`; header_file=`echo "$line" | cut -f5`; header_file_path=$(ls data/$sample_name/$header_file); echo ua $header_file_path --do-not-compress -f $nexus_path; ua $header_file_path --do-not-compress -f $nexus_path; done

#### NOT NEEDED ANYMORE ######
# run the generate bam header
# cat submission_20141210.worklist | while read line; do nexus_path=`echo "$line" | cut -f2`; bam_file=`echo "$line" | cut -f3`; bam_file_path=$nexus_path/$bam_file; incomplete_header_file=`echo "$line" | cut -f4`; incomplete_header_file_path=$nexus_path/$incomplete_header_file; output_header_file=`echo "$line" | cut -f5`; echo dx run generate-bam-header -i input_bam_file=$bam_file_path -i input_sq_rg_file=$incomplete_header_file_path -i output_header_filename=$output_header_file --destination=$nexus_path --brief; dx run generate-bam-header -i input_bam_file=$bam_file_path -i input_sq_rg_file=$incomplete_header_file_path -i output_header_filename=$output_header_file --destination=$nexus_path --brief; done
##############################

# run process bam
cat submission_20141210.worklist | while read line; do nexus_path=`echo "$line" | cut -f2`; bam_file=`echo "$line" | cut -f3`; bam_file_path=$nexus_path/$bam_file; input_header_file=`echo "$line" | cut -f5`; input_header_file_path=$nexus_path/$input_header_file; output_bam_filename=`echo "$line" | cut -f6`; echo dx run process-bam -i input_bam_file=$bam_file_path -i input_header_file=$input_header_file_path -i output_bam_filename=$output_bam_filename --destination=$nexus_path --brief; dx run process-bam -i input_bam_file=$bam_file_path -i input_header_file=$input_header_file_path -i output_bam_filename=$output_bam_filename --destination=$nexus_path --brief; done

