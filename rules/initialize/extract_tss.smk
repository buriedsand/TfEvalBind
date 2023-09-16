rule extract_tss:
    input:
        gtf="gencode.v44.basic.annotation.gtf"
    output:
        tss="assets/tss_positions.bed"
    shell:
        """
        # Convert GTF to BED
        awk '$3 == "gene" {{print $1, $4-1, $5, $10, $6, $7}}' {input.gtf} | tr -d '";' > temp_annotation.bed
        echo "Converted GTF to BED"

        # Extract TSS for each gene - positive strand
        awk 'BEGIN{{OFS="\t"}}; $6=="+"' temp_annotation.bed | awk 'BEGIN{{OFS="\t"}} {{print $1, $2, $2+1, $4, $5, $6}}' > temp_tss_positive.bed
        echo "Extracted TSS for positive strand"

        # Extract TSS for each gene - negative strand
        awk 'BEGIN{{OFS="\t"}}; $6=="-"' temp_annotation.bed | awk 'BEGIN{{OFS="\t"}} {{print $1, $3-1, $3, $4, $5, $6}}' > temp_tss_negative.bed
        echo "Extracted TSS for negative strand"

        # Concatenate the two TSS files
        cat temp_tss_positive.bed temp_tss_negative.bed > {output.tss}
        echo "Concatenated TSS files"

        # Cleanup temporary files
        rm temp_annotation.bed temp_tss_positive.bed temp_tss_negative.bed
        """
