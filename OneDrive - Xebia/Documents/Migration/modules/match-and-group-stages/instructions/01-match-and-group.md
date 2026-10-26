# $match and $group Stages

In this lab, you will learn how to use the `$match` and `$group` stages in MongoDB aggregation pipelines.

You have a database called `bird_data` with a collection of sightings. We want to find where to go to see **Eastern Bluebirds** by grouping sightings by location.

## Steps

1. Open the **mongosh** tab and switch to the database:

   ```js
   use bird_data
   ```

2. Create an aggregation pipeline with two stages.

3. Add a `$match` stage that filters for Eastern Bluebird sightings:

   ```js
   { $match: { species_common: 'Eastern Bluebird' } }
   ```

4. Add a `$group` stage that groups by location coordinates and counts sightings:

   ```js
   { $group: { _id: '$location.coordinates', number_of_sightings: { $count: {} } } }
   ```

5. Run the full pipeline and identify the best birdwatching locations!

## Hints

- An aggregation pipeline uses `db.<collection>.aggregate([stage1, stage2, ...])`
- The `location.coordinates` field uses `[longitude, latitude]` order.

## Solved Code

```js
db.sightings.aggregate([
  {
    $match: {
      species_common: 'Eastern Bluebird'
    }
  },
  {
    $group: {
      _id: '$location.coordinates',
      number_of_sightings: { $count: {} }
    }
  }
])
```
