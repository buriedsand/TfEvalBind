include: "jaccard_utils.smk"

rule compute_jaccard:
    input:
        bed_files=get_samples_from_checkpoint,
    params:
        chunk=get_chunk
    output:
        temp("{threshold}/jaccard_results_chunk_{idx}.txt")
    run:
        results = []
        for file1, file2 in params.chunk:
            cmd = f"bedtools jaccard -a {file1} -b {file2}"
            raw_result = shell(cmd, read=True)
            # Extract the jaccard value from the second line
            jaccard_value = raw_result.strip().split('\n')[1].split('\t')[2]
            formatted_result = f"{file1},{file2},{jaccard_value}"
            results.append(formatted_result)

        with open(output[0], 'w') as out:
            out.write('\n'.join(results) + '\n')
