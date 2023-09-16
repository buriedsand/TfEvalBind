rule download_and_decompress_gtf:
    output:
        gtf=temp("gencode.v44.basic.annotation.gtf")
    params:
        url="https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/gencode.v44.basic.annotation.gtf.gz"
    shell:
        """
        wget {params.url} -O - | gunzip -c > {output.gtf}
        """

rule download_and_decompress_genome:
    output:
        genome=temp("GRCh38.primary_assembly.genome.fa")
    params:
        url="https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/GRCh38.primary_assembly.genome.fa.gz"
    shell:
        """
        wget {params.url} -O - | gunzip -c > {output.genome}
        """
