#!/bin/bash
log=$(mongosh bird_data --quiet --eval "db.adminCommand({getLog:'global'})" 2>/dev/null | \
  grep -o '"aggregate".*"sightings".*"\$project"' | tail -1)
if [[ -z "$log" ]]; then
  fail-message "Please run an aggregation pipeline with a \$project stage on the sightings collection."
fi
