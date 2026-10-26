#!/bin/bash
# Check that the user ran an aggregate() pipeline with $match + $group on sightings
log=$(mongosh bird_data --quiet --eval "db.adminCommand({getLog:'global'})" 2>/dev/null | \
  grep -o '"aggregate".*"sightings".*"\$match".*"\$group"' | tail -1)

if [[ -z "$log" ]]; then
  fail-message "Please run an aggregation pipeline with \$match and \$group on the sightings collection."
fi
