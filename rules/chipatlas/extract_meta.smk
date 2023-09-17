rule extract_meta:
    input:
        profiles="profiles/{threshold}/preprocessed/{tf}.bed"
    output:
        meta=temp("data/{threshold}/meta/{tf}.csv")
    params:
        script="rules/chipatlas/extract_meta.py"
    shell:
        "python {params.script} {input.profiles} {output.meta}"