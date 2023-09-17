import pandas as pd
include: "rules/chipatlas/download.smk"
include: "rules/chipatlas/preprocess.smk"
include: "rules/chipatlas/extract_meta.smk"
include: "rules/chipatlas/isolate_profile.smk"

with open("assets/tf_options.txt", "r") as f:
    TF_LIST = [line.strip() for line in f.readlines()]

# Random sample
# TF_LIST = ['AATF', 'TLE3', 'CUX1', 'ASUN', 'ZNF211', 'INTS10']
include: "rules/chipatlas/aggregate_meta.smk"

# Number of samples per chunk
CHUNK_SIZE = 1000
include: "rules/jaccard/compute_jaccard.smk"
include: "rules/jaccard/aggregate_jaccard.smk"

rule all:
    input: expand("outputs/{threshold}/jaccard_results.txt", threshold=["05", "10", "20", "50"])

