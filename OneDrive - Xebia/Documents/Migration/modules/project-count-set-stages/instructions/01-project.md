# $project Stage

In this lab, you are connected to the `bird_data` database with a `sightings` collection. Each document contains many fields, but we want to return only the `date` and `species_common` fields.

## Steps

1. In the **mongosh** tab, switch to the database:

   ```js
   use bird_data
   ```

2. Create an aggregation pipeline with a `$project` stage that:
   - Includes `date` and `species_common`
   - Excludes `_id`

3. Run the pipeline.

## Hints

- `$project` takes an object where `1` includes a field and `0` excludes it.
- Excluding `_id` requires explicitly setting `_id: 0`.

## Solved Code

```js
db.sightings.aggregate([
  {
    $project: {
      _id: 0,
      date: 1,
      species_common: 1
    }
  }
])
```
