include: "jaccard_utils.smk"

rule aggregate_jaccard:
    input:
        lambda wildcards: expand("{{threshold}}/jaccard_results_chunk_{idx}.txt", idx=range(len(chunk_pairs(wildcards))))
    output:
        "outputs/{threshold}/jaccard_results.txt"
    shell:
        """
        cat {input} > {output}
        """