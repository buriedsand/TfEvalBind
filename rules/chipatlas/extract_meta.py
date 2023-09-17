import sys
import pandas as pd
from urllib.parse import unquote


def names_to_dataframe(names):
    """
    Convert a list of name strings into a DataFrame.
    """

    def decode_and_clean(s):
        """Decode URL encoded characters and remove HTML tags"""
        return unquote(s).replace("<br>", "")

    # Use list comprehension to generate list of dictionaries from names
    dicts = [
        {
            decode_and_clean(field.split("=")[0]): decode_and_clean(field.split("=")[1])
            for field in name.split(";")
            if "=" in field
        }
        for name in names
    ]

    # Convert list of dictionaries into a DataFrame
    return pd.DataFrame(dicts)


def extract_unique_names_from_bed(file_path):
    """
    Extracts the 'name' column (typically the fourth column) from a BED file.
    Returns a list of names where each name has a unique ID.
    """
    with open(file_path, "r") as f:
        names = [
            line.strip().split("\t")[3]
            for line in f
            if not line.startswith(("track", "browser", "#"))
            and len(line.split("\t")) > 3
            and "ID=" in line
        ]
        id_to_name = {name.split(";")[0].split("=")[1]: name for name in names}

    return list(id_to_name.values())


if __name__ == "__main__":
    file_path = sys.argv[1]
    output_path = sys.argv[2]
    unique_names = extract_unique_names_from_bed(file_path)

    df = names_to_dataframe(unique_names)
    df.to_csv(output_path, index=False)
