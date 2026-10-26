#!/bin/bash
mongosh bird_data --quiet --eval "db.sightings.aggregate([{ \$set: { sighting_year: { \$year: '\$date' } } }])"
