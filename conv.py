import os
import ast

def extract_request_line_from_bistream(file_path):
    with open(file_path, 'rb') as f:
        content = f.read()

    try:
        # The bistream files content starts with something like: stream = [...]
        stream_str = content.decode(errors='ignore').replace("stream = ", "", 1)
        stream = ast.literal_eval(stream_str)

        for direction, data in stream:
            if direction == 'in':
                lines = data.decode(errors='ignore').splitlines()
                if lines:
                    return lines[0]
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
    return None

def extract_all_requests(directory):
    for filename in os.listdir(directory):
        filepath = os.path.join(directory, filename)
        if os.path.isfile(filepath):
            request_line = extract_request_line_from_bistream(filepath)
            if request_line:
                print(f"{filename}: {request_line}")

if __name__ == "__main__":
    bistream_dir = "/opt/dionaea/var/lib/dionaea/bistreams/2025-05-22"
    extract_all_requests(bistream_dir)
