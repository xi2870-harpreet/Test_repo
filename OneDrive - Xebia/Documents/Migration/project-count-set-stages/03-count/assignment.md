---
slug: count
id: lhizo6sdrv1a
type: challenge
title: $count Stage
teaser: Learn how to use the $count aggregation stage in MongoDB
notes:
- type: text
  contents: Congratulations! You've learned how to use the $set aggregation stage
    to change and add fields to your data. In the next activity, you'll practice using
    the $count stage.
tabs:
- id: kyx2u2cesadv
  title: mongosh
  type: terminal
  hostname: mongodb
  cmd: /scripts/mongosh.sh
- id: izzuyezasraz
  title: terminal
  type: terminal
  hostname: mongodb
  workdir: /lab
  cmd: /bin/bash
difficulty: basic
timelimit: 600
enhanced_loading: null
---



📥 Instructions
===

You are now connected to the `[[ Instruqt-Var key="DB_NAME" hostname="mongodb" ]]` database with a collection of sightings. We want to see the total number of sightings of Eastern Bluebirds in 2022.

Use the `[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]]` collection in this lab.

1. Create an aggregation pipeline on the `[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]]` collection. _(Forgot the command or aggregation stages? Check the [Hints](section-hints) section below!)_
2. Create a stage that finds matches where `species_common` is "Eastern Bluebird" and where the `date` field is a value between January 1, 2022 0:00, and January 1, 2023 0:00.
3. Create a stage to count how many sightings that includes.
4. Run your aggregation pipeline, and see how many sightings of Eastern Bluebirds took place in 2022.

Once you have completed the lab, select the **Check** button.

[[ Instruqt-Var key="USER_FIRSTNAME_CLOSING_MSG" hostname="mongodb" ]]

💡 Hints
===

- Remember that an aggregation pipeline must start with `db.<collection>.aggregate([])` in the MongoDB shell.
- Use the `$match` stage to find specific documents. `$match` takes a query, where you should:
  - Specify dates after the first day of 2022 using `$gt: ISODate("2022-01-01T00:00:00.0Z")`
  - Specify dates before the first day of 2023 using `$lt: ISODate("2023-01-01T00:00:00.0Z")`
  - Specify `species_common` is "Eastern Bluebird".
- Use the `$count` stage to show how many Bluebird sightings there were in a field called "Bluebird_sightings_2022"

🏁 Review and Solved Code
===

You can access the collection you want to use with dot notation:

```js
db.sightings
```

Use the `aggregate` method to set up the aggregation pipeline.

The first aggregation stage will be `$match` which will find documents where the `date` field contains a value greater than `ISODate("2022-01-01T00:00:00.0Z")` and less than `ISODate("2023-01-01T00:00:00.0Z")`. The `$match` stage will also find documents where the `species_common` field is "Eastern Bluebird".

```js,run
db.[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]].aggregate([
  {
    $match: {
        date: {
            $gt: ISODate('2022-01-01T00:00:00.0Z'),
            $lt: ISODate('2023-01-01T00:00:00.0Z')
        },
        species_common: 'Eastern Bluebird'
    }
  }
])
```

The last stage that we include is `$count`. The `$count` stage creates a field called `bluebird_sightings_2022`, which includes the value from the count of how many documents are currently in the pipeline.

```js,run
db.[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]].aggregate([
  {
    $match: {
      date: {
        $gt: ISODate('2022-01-01T00:00:00.000Z'),
        $lt: ISODate('2023-01-01T00:00:00.000Z')
      },
      species_common: 'Eastern Bluebird'
    }
  }, {
    $count: 'bluebird_sightings_2022'
  }
])
```

## Solved Code

```js,run
db.[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]].aggregate([
{
  $match: {
    date: {
      $gt: ISODate('2022-01-01T00:00:00.000Z'),
      $lt: ISODate('2023-01-01T00:00:00.000Z')
    },
    species_common: 'Eastern Bluebird'
  }
}, {
  $count: 'bluebird_sightings_2022'
}
])
```

👨‍💻 Troubleshooting
==================

- If you encounter an errors when interacting with the server while using the MongoDB Shell, you restart the MongoDB server by running the following command in the [button label="terminal"](tab-1) tab:

  ```bash,run
  mongod --shutdown --config /etc/mongod.conf && mongod --config /etc/mongod.conf
  ```

  After restarting the server, it is a good idea to refresh the tab using the reload button located in the top right corner of the [button label="mongosh" variant="success"](tab-0) tab.

- If the [button label="mongosh"](tab-0) or [button label="terminal"](tab-1) tab is blank, refresh your web browser to reload the lab.

- If the `mongosh` connection is terminated accidentally, reload the [button label="mongosh" variant="success"](tab-0) tab by clicking the reload button.

  ![A screenshot showing the reload button for the mongosh tab ](https://mdb-univ-curriculum-labs.s3.amazonaws.com/mongosh_refresh_mt.png)

  - If you encounter a "Session closed" error in the terminal, reload the window by clicking the reload button. This may require a few attempts. If this fails, restart your browser. If you continue to get this error, exit the lab and retry it from [learn.mongodb.com](https://learn.mongodb.com).

    ![A screenshot showing the reload button for the virtual lab environment](https://mdb-univ-curriculum-labs.s3.amazonaws.com/session_closed_mt.png)

- To scroll back in the terminal, use the **Shift + Page Up** keys. To scroll forward in the terminal, use the **Shift + Page Down** keys.

- If you are still experiencing issues after several attempts, please post in our community forums at [mongodb.com/community/forums](https://www.mongodb.com/community/forums) or email us at [learn@mongodb.com](mailto:learn@mongodb.com).
