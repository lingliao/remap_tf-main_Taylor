#!/bin/bash
remap=/data/sundbyrt/repos/remap/data/remap2022_crm_macs2_hg38_v1_0.bed
tf="HOXB8"
bam=/data/panalc/cfdna-wgs-data/analysis/cfdna_wgs/bams/lib448_filt.bam ###for test, map to specific file
out_tsv=/data/sundbyrt/repos/remap/analysis/lib130_FOXA2_counts

remap="${1}"
tf="${2}"
bam="${3}"
out_tsv="${4}"

cat $remap |
# filter remap to remove non-autosome sites 
grep -Ev '_|chrM|chrX|chrY' |
# filter to only sites for transcription factor 
grep $tf |
# generate bed coordinates at +/- 3k from site center
awk '{print $1, (($2+($3-$2)/2)-3000), (($2+($3-$2)/2)+3000)}' |    
# Just take bed heavy mark
awk -v OFS='\t' '{print $1, ($7-3000), ($7+3000)}' |
# round coordinate values to whole number
awk '{ printf ("%s\t%.0f\t%.0f\n", $1, int($2), int($3)) }' |
# get bam coverage
coverageBed -a stdin -b $bam -d > $out_tsv
# summarize coverage per site position
awk -v F'\t' OFS=FS '{counts[$4]+=$5} END {for (i in counts) print i, counts[i]}' > $out_tsv
awk -F'\t' '{counts[$4]+=$5} END {for (i in counts) print i, counts[i]}'
