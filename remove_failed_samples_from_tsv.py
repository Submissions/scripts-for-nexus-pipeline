#!/usr/bin/env python

import collections
import os
import sys

qc_log_file = sys.argv[1]
tsv_file = sys.argv[2]

file_prefix = os.path.splitext(tsv_file)[0]
file_suffix = os.path.splitext(tsv_file)[1]

passed_qc_tsv = os.path.join(file_prefix + '_passed_qc' + file_suffix)
failed_qc_tsv = os.path.join(file_prefix + '_failed_qc' + file_suffix)

print qc_log_file, tsv_file, passed_qc_tsv, failed_qc_tsv

samples = set()
tsv_map = collections.defaultdict(list)
with open(tsv_file) as f:
    for raw_line in f:
        line = raw_line.rstrip()
        sample = line.split('\t')[0]
        samples.add(sample)
        tsv_map[sample].append(line)
        
qc_failed_samples = []
with open(qc_log_file) as f:
    for raw_line in f:
        line = raw_line.rstrip()
        if line.startswith('ERROR'):
            qc_failed_samples.append(line.split()[1])

print len(tsv_map), len(samples), len(qc_failed_samples)

for sample in samples:
    if sample in qc_failed_samples:
        for value in tsv_map[sample]:
            with open(failed_qc_tsv, 'a') as f:
                f.write(value + '\n')
    else:
        for value in tsv_map[sample]:
            with open(passed_qc_tsv, 'a') as f:
                f.write(value + '\n')
