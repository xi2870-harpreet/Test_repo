#!/bin/bash
log=$(mongosh bird_data --quiet --eval "db.adminCommand({getLog:'global'})" 2>/dev/null | \
  grep -o '"aggregate".*"sightings".*"\$set"' | tail -1)
if [[ -z "$log" ]]; then
  fail-message "Please run an aggregation pipeline with a \$set stage on the sightings collection."
fi
