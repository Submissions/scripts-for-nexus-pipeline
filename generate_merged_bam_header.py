#!/usr/bin/env python

import os
import sys


sample = sys.argv[1]
tsv_file = sys.argv[2]
rg_incomplete_file = sys.argv[3]
project = sys.argv[4]


tsv_header_info = {}
with open(tsv_file) as f:
    for raw_line in f:
        line = raw_line.rstrip()
        if line.startswith(sample):
            tsv_header_info[line.split('\t')[3]] = line.split('\t')[1], line.split('\t')[5]


with open(rg_incomplete_file) as f:
    for raw_line in f:
        line = raw_line.rstrip()
        id = pu = lb = sm = ds = cn = None
        for rg_value in line.split('\t'):
            if rg_value == "@RG":
                pass
            else:
                key, value = rg_value.split(":")
                if 'ID' in key:
                    id = key + ":" + value
                elif 'PU' in key:
                    pu_barcode = value.split('_')[2]
                    if tsv_header_info[pu_barcode]:
                        lb_value, pu_value = tsv_header_info[pu_barcode]
                        pu = key + ":" + pu_value
                    else:
                        print "ERROR: %s doesn't exist match the value in the tsv" %(pu_barcode)
                elif 'LB' in key:
                    assert lb_value == value         # assumption : one library name exists for both runs
                    lb = key + ':' + lb_value
                elif 'SM' in key:
                    sm = key + ":" + sample
                else:
                    pass
            ds = "DS:" + project
            cn = "CN:BCM"
        print "@RG\t%s\t%s\t%s\t%s\t%s\t%s" %(id, lb, pu, sm, ds, cn)


