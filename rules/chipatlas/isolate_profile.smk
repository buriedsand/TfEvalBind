rule isolate_profile:
    input:
        profiles="profiles/{threshold}/preprocessed/{tf}.bed"
    output:
        profiles=temp("profiles/{threshold}/samples/{tf}/{id}.bed")
    shell:
        """
        awk -F'\t' '$4 ~ /^ID={wildcards.id};/ {{print}}' {input.profiles} > {output.profiles}
        """
