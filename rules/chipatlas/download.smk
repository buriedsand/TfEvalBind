URL_TEMPLATE = "https://chip-atlas.dbcls.jp/data/hg38/assembled/Oth.ALL.{}.{}.AllCell.bed"

rule download_profiles:
    output:
        profiles=protected("profiles/{threshold}/raw/{tf}.bed")
    params:
        url=lambda wildcards: URL_TEMPLATE.format(wildcards.threshold, wildcards.tf)
    shell:
        """
        wget {params.url} -O {output.profiles}
        """