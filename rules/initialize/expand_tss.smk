rule expand_tss:
    input:
        tss="assets/tss_positions.bed",
        genome_sizes="assets/genome.sizes"
    output:
        expanded="assets/tss_expanded.bed"
    shell:
        """
        sort -k1,1 -k2,2n {input.tss} | bedtools slop -g {input.genome_sizes} -b 5000 > {output.expanded}
        """
