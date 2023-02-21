#! /bin/bash

cd /data/sundbyrt/repos/remap
module load snakemake


# dry run:
# snakemake --profile profile/ --snakefile workflow/tf_bam.smk --keep-going -np

snakemake \
--profile profile/ \
--snakefile workflow/tf_bam.smk \
--keep-going

# run:
# sbatch --mem=1g --cpus-per-task=2 --time=96:00:00 /data/sundbyrt/repos/remap/remap.sh
