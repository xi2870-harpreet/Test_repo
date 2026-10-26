# $set Stage

Great work! Now you'll use the `$set` stage to add a new computed field to your documents.

## Steps

1. Create an aggregation pipeline on the `sightings` collection.

2. Add a `$set` stage that adds a field called `sighting_year` derived from the `date` field:

   ```js
   { $set: { sighting_year: { $year: '$date' } } }
   ```

3. Run the pipeline and verify the new field appears.

## Hints

- `$set` adds or overwrites fields without removing others — unlike `$project`.
- Use date operators like `$year`, `$month`, `$dayOfMonth` to extract date parts.

## Solved Code

```js
db.sightings.aggregate([
  {
    $set: {
      sighting_year: { $year: '$date' }
    }
  }
])
```
