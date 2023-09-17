checkpoint aggregate_meta:
    input:
        files=["data/{{threshold}}/meta/{}.csv".format(tf) for tf in TF_LIST]
    output:
        master="outputs/{threshold}/master.csv"
    run:
        import pandas as pd

        # Read each CSV into a dataframe and store in a list
        dfs = [pd.read_csv(f) for f in input.files]

        # Concatenate all dataframes in the list into a master dataframe
        master_df = pd.concat(dfs, axis=0)

        # Column for TF name
        master_df["TF"] = master_df["Name"].str.split().map(lambda x: x[0])

        # Reorder columns to have "TF" as the second column
        cols = master_df.columns.tolist()
        cols.insert(1, cols.pop(cols.index("TF")))
        master_df = master_df[cols]

        # Write the master dataframe to the output CSV
        master_df.to_csv(output.master, index=False)