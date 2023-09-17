import pandas as pd
import itertools

def get_samples_from_checkpoint(wildcards):
    template = "profiles/{}/samples/{}/{}.bed"
    checkpoint_output = checkpoints.aggregate_meta.get(**wildcards).output.master
    df = pd.read_csv(checkpoint_output)
    return [template.format(wildcards.threshold, tf, id) for id, tf in zip(df["ID"], df["TF"])]

def chunk_pairs(wildcards):
    """Generate non-redundant pairs of bed files and divide them into smaller lists of size CHUNK_SIZE."""
    bed_files = get_samples_from_checkpoint(wildcards)
    all_pairs = list(itertools.combinations(bed_files, 2))
    return [all_pairs[i:i+CHUNK_SIZE] for i in range(0, len(all_pairs), CHUNK_SIZE)]

def get_chunk(wildcards):
    """Retrieve the specific chunk of bed file pairs corresponding to the given index from the list of all chunks."""
    all_chunks = chunk_pairs(wildcards)
    return all_chunks[int(wildcards.idx)]
