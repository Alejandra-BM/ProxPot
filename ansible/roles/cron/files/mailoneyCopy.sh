#!/bin/bash

# Define paths
TEMP_FILE="/tmp/mailoney_temp.json"
DEST_FILE="/opt/mailoney/mailoney.json"
LAST_ID_FILE="/var/log/mailoney_last_id.txt"

# Get the last ID we processed
if [ -f "$LAST_ID_FILE" ]; then
    LAST_ID=$(cat "$LAST_ID_FILE")
else
    LAST_ID=0
fi

# Ensure destination directory exists
mkdir -p "$(dirname "$DEST_FILE")"

# Create destination file if it doesn't exist
touch "$DEST_FILE"

# Query only new records since the last ID
docker exec -i mailoney_db_1 psql -U postgres -d mailoney -c "\
COPY (
  SELECT row_to_json(t)
  FROM (
    SELECT
      id,
      timestamp,
      ip_address,
      port,
      server_name,
      session_data::jsonb AS session_data
    FROM smtp_sessions
    WHERE id > $LAST_ID
    ORDER BY id ASC
  ) t
) TO STDOUT;" > "$TEMP_FILE"

# If we got any new records
if [ -s "$TEMP_FILE" ]; then
    # Write each JSON object to a new line (if not already in jsonlines format)
    jq -c . "$TEMP_FILE" | while IFS= read -r line; do
        echo "$line" >> "$DEST_FILE"
    done

    # Get the highest ID from the new records
    NEW_LAST_ID=$(grep -o '"id":[0-9]*' "$TEMP_FILE" | sed 's/"id"://g' | sort -n | tail -1)

    # Update last ID marker
    if [ -n "$NEW_LAST_ID" ]; then
        echo "$NEW_LAST_ID" > "$LAST_ID_FILE"
        echo "Appended records up to ID $NEW_LAST_ID"
    fi
else
    echo "No new mailoney records"
fi

# Clean up
rm -f "$TEMP_FILE"
