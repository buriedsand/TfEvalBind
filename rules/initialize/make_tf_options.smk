rule make_tf_options:
    output:
        options="assets/tf_options.txt"
    params:
        html_options="assets/tf_options.html",
        script="rules/initialize/tf_options.py"
    shell:
        "python {params.script} {params.html_options} {output.options}"