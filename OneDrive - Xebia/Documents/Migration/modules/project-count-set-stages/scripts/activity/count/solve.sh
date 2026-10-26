#!/bin/bash
mongosh bird_data --quiet --eval "
db.sightings.aggregate([
  { \$match: { species_common: 'Eastern Bluebird' } },
  { \$count: 'total_eastern_bluebird_sightings' }
])
"
