#!/bin/bash

# Define paths
TEMP_FILE="/tmp/cowrie_temp.json"
DEST_FILE="/opt/cowrie/var/log/cowrie/cowrie.json"
MARKER_FILE="/var/log/cowrie_last_bytes.txt"

# Get the current size of the destination file if it exists
if [ -f "$DEST_FILE" ]; then
    CURRENT_SIZE=$(stat -c %s "$DEST_FILE")
else
    CURRENT_SIZE=0
    touch "$DEST_FILE"
fi

# Save current size to marker file
echo "$CURRENT_SIZE" > "$MARKER_FILE"

# Copy the container file to a temp location
docker cp docker_cowrie_1:/cowrie/cowrie-git/var/log/cowrie/cowrie.json "$TEMP_FILE"

# If temp file exists and is different from current file
if [ -f "$TEMP_FILE" ]; then
    TEMP_SIZE=$(stat -c %s "$TEMP_FILE")
    
    # If temp file is larger than our current file
    if [ "$TEMP_SIZE" -gt "$CURRENT_SIZE" ]; then
        # Extract only the new content and append it
        tail -c +$((CURRENT_SIZE + 1)) "$TEMP_FILE" >> "$DEST_FILE"
        echo "Appended $((TEMP_SIZE - CURRENT_SIZE)) bytes of new data"
    elif [ "$TEMP_SIZE" -lt "$CURRENT_SIZE" ]; then
        # Container log was rotated or truncated, copy the whole file
        cp "$TEMP_FILE" "$DEST_FILE"
        echo "Log file was truncated in container, copied full file"
    else
        echo "No new content"
    fi
    
    # Clean up
    rm "$TEMP_FILE"
else
    echo "Failed to copy from container"
fi

# Remove the folder if it exists to avoid flooding
rm -rf /tmp/cowrie-downloads/

# Create the folder again to copy files into it
mkdir -p /tmp/cowrie-downloads/

# Copy the downloads folder fresh from container
docker cp docker_cowrie_1:/cowrie/cowrie-git/var/lib/cowrie/downloads/ /tmp/cowrie-downloads/

# Sync new files to /opt/cowrie/logs using rsync to avoid duplicates
rsync -av --ignore-existing /tmp/cowrie-downloads/ /opt/cowrie/logs/
