##################################################################################
###   Evaluate of relative coverage at ReMap sites: TFBS/enhancer discovery   ###
###      Starting files: aligned, deduped .bam  & TF list                     ###
###      Author: Taylor Sundby                                                ###
###      Date: 2-16-23                                                        ###
##################################################################################

import pandas as pd

configfile: "config/config.yaml"

# Load sample and TF lists
lib_df = pd.read_csv(config["samples"])
print(lib_df)

tf_list = pd.read_csv(config["repo_dir"] + "/data/remap_tf_list.csv")
print(tf_list) 

# Define rule for each TF/bam combination
rule all:
    input:
        expand(config["output_dir"] + "/{sample}_{tf}_counts.tsv",
            sample=lib_df["lib_id"],
            tf=tf_list["tf"],
        ),

rule count_coverage:
    resources:
        time="24:00:00",
        mem_gb="40g",
        cpus="10",
    input:
        bam = config["input_dir"] + "/{sample}_dedup.bam",
    output:
        out_tsv = config["output_dir"] + "/{sample}_{tf}_counts.tsv",
    params:
        script=config["repo_dir"] + "/workflow/remap-parse-smk.sh",
        remap=config["remap"],
        tf=tf_list["tf"],
    log:
	    config["repo_dir"] + "/log/tf_relative_count_coverage/{sample}_{tf}.log",
    shell:
        """
        {params.script} \
        {params.remap} \
        {params.tf} \
        {input.bam} \
        {output.out_tsv} \
        {resources.cpus} \
        &> {log}
        """