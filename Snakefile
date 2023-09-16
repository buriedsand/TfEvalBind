include: "rules/initialize/download_data.smk"
include: "rules/initialize/generate_chrom_sizes.smk"
include: "rules/initialize/extract_tss.smk"
include: "rules/initialize/expand_tss.smk"

rule all:
    input:
        "assets/tss_expanded.bed"
