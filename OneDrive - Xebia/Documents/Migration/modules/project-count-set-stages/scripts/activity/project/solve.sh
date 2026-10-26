#!/bin/bash
mongosh bird_data --quiet --eval "db.sightings.aggregate([{ \$project: { _id: 0, date: 1, species_common: 1 } }])"
