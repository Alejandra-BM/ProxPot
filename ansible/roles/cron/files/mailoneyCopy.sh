#!/bin/bash

# Convert mailoney logs into JSON files for processing
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
  ) t
) TO STDOUT;" > /opt/mailoney/mailoney.json
