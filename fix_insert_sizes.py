#!/usr/bin/env python

import os
import sys

tsv_file = sys.argv[1]
info_file = sys.argv[2]
barcode_pos = int(sys.argv[3])
insert_size_pos = int(sys.argv[4])

output_filename = os.path.splitext(tsv_file)[0] + '_correct_insert_size' + os.path.splitext(tsv_file)[1]

info_map = {}
with open(info_file) as f:
    for raw_line in f:
        line = raw_line.rstrip()
        barcode = line.split('\t')[barcode_pos]
        insert_size = line.split('\t')[insert_size_pos]
        info_map[barcode] = insert_size


with open(tsv_file) as f:
    for raw_line in f:
        line = raw_line.rstrip()
        barcode = line.split('\t')[3]
        tsv_insert_size = line.split('\t')[15]
        final_insert_size = None

        if 'ERROR' in tsv_insert_size:
            final_insert_size = info_map[barcode]
        elif 'MANUAL' in tsv_insert_size:
            final_insert_size = info_map[barcode]
        else:
            final_insert_size = tsv_insert_size
            
        final_line = line.replace(tsv_insert_size, final_insert_size)
        
        with open(output_filename, 'a') as of:
            of.write(final_line + '\n')
