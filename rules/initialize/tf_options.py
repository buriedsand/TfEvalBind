import re
import sys


def extract_option_values(file_path):
    """Extract option values from the given file path."""
    with open(file_path, "r") as f:
        content = f.read()
    return re.findall(r'<option value="([^"]+)">', content)


def write_values_to_file(values, file_path):
    """Write the provided values to a file, one per line."""
    with open(file_path, "w") as f:
        for value in values:
            f.write(f"{value}\n")


def main():
    if len(sys.argv) != 3:
        print("Usage: script.py <input_file> <output_file>")
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2]

    try:
        option_values = extract_option_values(input_path)
        write_values_to_file(option_values, output_path)
    except FileNotFoundError:
        print(f"Error: File {input_path} not found.")
        sys.exit(1)
    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
