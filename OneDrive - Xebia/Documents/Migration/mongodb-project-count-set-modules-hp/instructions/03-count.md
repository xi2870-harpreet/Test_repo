# $count Stage

You've learned `$project` and `$set`. Now use `$count` to count documents that match a condition.

## Steps

1. Create an aggregation pipeline that:
   - First, uses `$match` to filter for Eastern Bluebird sightings
   - Then, uses `$count` to count how many sightings there are

2. Run the pipeline.

## Hints

- `$count` takes a single string argument: the name of the output field.
- Example: `{ $count: 'total' }` outputs `{ total: <number> }`.

## Solved Code

```js
db.sightings.aggregate([
  { $match: { species_common: 'Eastern Bluebird' } },
  { $count: 'total_eastern_bluebird_sightings' }
])
```
