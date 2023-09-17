rule preprocess_profiles:
    input:
        profiles="profiles/{threshold}/raw/{tf}.bed"
    output:
        profiles="profiles/{threshold}/preprocessed/{tf}.bed"
    params:
        blacklist="assets/ENCFF356LFX.bed"
    shell:
        """
        bedtools subtract -a {input.profiles} -b {params.blacklist} > {output.profiles}
        """