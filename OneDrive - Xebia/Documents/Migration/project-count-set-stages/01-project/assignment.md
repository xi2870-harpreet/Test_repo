---
slug: project
id: i5yujs7l9w1o
type: challenge
title: $project Stage
teaser: In this lab, you will learn how to use the $project aggregation stage in MongoDB
notes:
- type: video
  url: https://mdb-univ-curriculum-labs.s3.amazonaws.com/ShortLabLoadingPlaceholder.mp4
- type: text
  contents: In this lab, you will learn how to use the $project aggregation stage
    in a MongoDB collection using the MongoDB shell, mongosh. One moment while we
    create an environment for you to work in.
tabs:
- id: xi1sjmft44hd
  title: mongosh
  type: terminal
  hostname: mongodb
  cmd: /scripts/mongosh.sh
- id: 0bkqcrbkrfvn
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

[[ Instruqt-Var key="USER_FIRSTNAME_WELCOME_MSG" hostname="mongodb" ]] You are now connected to the `[[ Instruqt-Var key="DB_NAME" hostname="mongodb" ]]` database with a collection of `[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]]`.
There is a lot of data in each document, but we want to return only a list of the time of the sighting and the common name of the bird that was sighted.

Use the `[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]]` collection in this lab.

1. Create an aggregation pipeline on the `[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]]` collection. (Forgot the command or aggregation stages? Check the [Hints](section-hints) section below!)
2. Create a `$project` stage that just shows us the "date" and "species_common" field. Project out the "_id" field.
3. Run your aggregation pipeline, and see the list of sightings!

Once you have completed the lab, select the **Check** button.

💡 Hints
===

- Remember that an aggregation pipeline must start with `db.<collection>.aggregate([])` in the MongoDB shell.
- The aggregation stage will be a `$project` stage, which only shows us the specified fields to make the data easier to look at.

🏁 Review and Solved Code
===

You can access the collection you want to use with dot notation:

```js
db.[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]]
```

Use the `aggregate` method to set up the aggregation pipeline.

The aggregation stage will be `$project` which shows the indicated fields in each record of our collection. In this case, `species_common` and `date`. We don't need to see the _id, so we can project that field out by setting it’s value to 0 in the `$project` stage.

```js,run
db.[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]].aggregate([
  {
    $project: {
        _id: 0,
        species_common: 1,
        date: 1
    }
  }
])
```

## Solved Code

```js,run
db.[[ Instruqt-Var key="COLLECTION_NAME" hostname="mongodb" ]].aggregate([
  {
    $project: {
        _id: 0,
        species_common: 1,
        date: 1
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
