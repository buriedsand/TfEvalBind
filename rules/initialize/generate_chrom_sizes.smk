rule generate_chrom_sizes:
    input:
        genome="GRCh38.primary_assembly.genome.fa"
    output:
        chrom_sizes="assets/genome.sizes"
    shell:
        """
        samtools faidx {input.genome}
        cut -f1,2 {input.genome}.fai > {output.chrom_sizes}
        rm {input.genome}.fai
        """