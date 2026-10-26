---
slug: match-and-group
id: 23hew6fpm1ru
type: challenge
title: $match and $group Stages
teaser: In this lab, you'll learn how to use the $match and $group aggregation stages
  in MongoDB
notes:
- type: video
  url: https://mdb-univ-curriculum-labs.s3.amazonaws.com/ShortLabLoadingPlaceholder.mp4
- type: text
  contents: |-
    In this lab, you will learn how to use the $match and $group aggregation stages in
    a MongoDB collection using the MongoDB shell, mongosh. One moment while we create
    an environment for you to work in.
tabs:
- id: uuxbcj6qpdxb
  title: mongosh
  type: terminal
  hostname: mongodb
  cmd: /scripts/mongosh.sh
- id: pxde3z8aqupe
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

[[ Instruqt-Var key="USER_FIRSTNAME_WELCOME_MSG" hostname="mongodb" ]]. In this lab,you will learn how to use the `$match` and `$group` stages.

You have a database called `[[ Instruqt-Var key="DB_NAME" hostname="mongodb" ]]` with a collection of sightings. We want to use this data to find out where we should go to see our favorite bird, Eastern Bluebirds. We’ll use the location coordinates (latitude and longitude) and the number of sightings in each location to identify the best places to view the Eastern Bluebirds.

You are now connected to an Atlas cluster and to the `[[ Instruqt-Var key="DB_NAME" hostname="mongodb" ]]` database.
Use the `[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]]` collection in this lab.

  1. First, create an aggregation pipeline, which will contain two stages. (Forgot the method for aggregation? Check the hint below!)

  2. Create a `$match` stage that filters for documents about our target bird with the `species_common` value, "Eastern Bluebird"

  3. Create a `$group` stage that groups documents based on the latitude and longitude of the sighting, stored in the `location.coordinates` field.

  4. Within the groups, create a field to show the `$count` of how many documents are in each group, called "number_of_sightings".

  5. Run your aggregation pipeline, and find out where to look for Eastern Bluebirds!

  6. Once you complete this lab, compare your answer to the correct answer in the Review and Solved Code section, then select Next.

💡 Hints
===

- Remember that an aggregation pipeline must start with `db.<collection>.aggregate([])` in the MongoDB shell.
- The first stage will be a `$match` stage, which takes a query to find specific documents.
- The second stage will be a `$group` stage, which will require:
  - `_id`, the field used to group the documents
  - `$count`, the accumulator operator used to count the number of documents in each group
- The schema for the documents in the `sightings` collection uses a coordinates array to track the `location` of the bird sighting, the first element (0) is longitute and the second element (1) is latitude, `{ location: { coordinates: [x, y] } }`.

🏁 Review and Solved Code
===

You can access the collection you want to use with dot notation:

```js
db.[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]]
```

Use the `aggregate` method to set up the aggregation pipeline.

The first stage will be `$match` which accepts a simple query to filter for specific documents. In this case, we use the `species_common`field to query for our favorite bird, the Eastern Bluebird.

```js,run
db.[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]].aggregate([
  {
    $match: {
        species_common: 'Eastern Bluebird'
    }
  }
])
```

Then we want to see how many sightings occured at each location, so we can go to the place where we are most likely to see an Eastern Bluebird. To do this, we will use `$group` and set the required `_id` field to be the location coordinates, and create a field for the number of sightings, using `$count` to total the number of records at each of the coordinate points.

```js,run
db.[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]].aggregate([
  {
    $match: {
        species_common: 'Eastern Bluebird'
    }
  }, {
    $group: {
        _id: '$location.coordinates',
        number_of_sightings: { $count: {} }
    }
  }
])
```

## Solved Code

```js,run
db.[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]].aggregate([
  {
    $match: {
        species_common: 'Eastern Bluebird'
    }
  }, {
    $group: {
        _id: '$location.coordinates',
        number_of_sightings: {
            $count: {}
        }
    }
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
