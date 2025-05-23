#Analyzes bistreams from dionaea
import os

dir_path = '/opt/dionaea/var/lib/dionaea/bistreams/2025-05-22/'

for filename in os.listdir(dir_path):
    filepath = os.path.join(dir_path, filename)
    with open(filepath, 'rb') as f:
        content = f.read()
        print(f"=== {filename} ===")
        print(content)  # or do custom decoding here
        print()
