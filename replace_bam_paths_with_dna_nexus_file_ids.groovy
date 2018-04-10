#!/usr/bin/env groovy

if(args.size() != 6)
{
    println "usage: replace_bam_paths_with_dna_nexus_file_ids.groovy <tsv file> <info file> <nexus project id> <position of barcode in the info file> <position of nexus file id in the info file> <position of bam file name in the info file>"
    println "column in the info file starts at 0th position"
    System.exit(-1)
}

// generated from metadata-lookup; has fixed columns
def tsv_file = new File(args[0])

// can contain random columns
def bam_paths_file = new File(args[1])
def project_id = args[2]
def barcode_position = args[3].toInteger()
def file_id_position = args[4].toInteger()
def bam_position = args[5].toInteger()

println "tsv file: ${tsv_file.name}"
println "bam paths file: ${bam_paths_file.name}"
println "nexus project id: ${project_id}"
println "barcode position: ${barcode_position}"
println "bam position: ${bam_position}"

barcode_path_map = get_bam_paths(bam_paths_file, project_id, barcode_position, file_id_position, bam_position)

replace_bam_paths(tsv_file, barcode_path_map)

def get_bam_paths(bam_paths_file, project_id, barcode_pos, file_id_pos, bam_pos)
{
    def path_map = [:]
    bam_paths_file.eachLine
    {
        line->
	barcode = line.split('\t')[barcode_pos]
	file_id = line.split('\t')[file_id_pos]
	bam_file_name = line.split('\t')[bam_pos]
	path = "${project_id}:${file_id}=${bam_file_name}"
	path_map[barcode] = path
    }
    return path_map
}

def replace_bam_paths(tsv_file, barcode_path_map)
{
    def out_filename = "${tsv_file.name}".replace('.tsv', '_correct_bam_file_ids.tsv')
    def out_file_handle = new File(out_filename)
    println "\n************************************"
    println "writing out new bam paths to ${out_filename}"

    tsv_file.eachLine
    {
        line->
	tsv_barcode = line.split('\t')[3]
	path_1 = line.split('\t')[4]
	path_2 = line.split('\t')[6]

        if(barcode_path_map[tsv_barcode])
        {
            if(path_1 == path_2)
            {
                path = path_1
	        line = line.replace(path, barcode_path_map[tsv_barcode])
            }
            else
            {
	        temp_line = line.replace(path_1, barcode_path_map[tsv_barcode])
	        line = temp_line.replace(path_2, barcode_path_map[tsv_barcode])
            }
	    out_file_handle << line + '\n'
        }
	else
	{
	    println "\nERROR: path missing for barcode: ${tsv_barcode}"
	}
    }
}
