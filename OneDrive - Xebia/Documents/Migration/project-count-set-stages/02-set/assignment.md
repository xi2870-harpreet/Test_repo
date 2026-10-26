---
slug: set
id: ttdc8zd9cbn2
type: challenge
title: $set Stage
teaser: In this lab, you will learn how to use the $set aggregation stage in MongoDB
notes:
- type: text
  contents: Congratulations! You've learned how to use the $project aggregation stage
    to re-shape your data, showing just the fields you need to see. Next, you will
    use the $set stage to add a new field.
tabs:
- id: zdchycsb3vgy
  title: mongosh
  type: terminal
  hostname: mongodb
  cmd: /scripts/mongosh.sh
- id: x1tqyfjto1ff
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

You are now connected to the `[[ Instruqt-Var key="DB_NAME" hostname="mongodb" ]]` database with a collection of information about bird species. In the future, we’ll add new animals to the database and collection. Before we do that, we have to add a `class` field and set that field to `[[ Instruqt-Var key="BIRDS_COLLECTION_NAME" hostname="mongodb" ]]` in all of the existing documents in the collection

Use the `[[ Instruqt-Var key="BIRDS_COLLECTION_NAME" hostname="mongodb" ]]` collection in this lab.

1. Create an aggregation pipeline on the `[[ Instruqt-Var key="BIRDS_COLLECTION_NAME" hostname="mongodb" ]]` collection. _(Forgot the command or aggregation stages? Check the [Hints](section-hints) section below!)_
2. Create a new field called `class` populated with the class of each of these animals, bird.
3. Run your aggregation pipeline, and see that the `class` field has been added and set to "bird".

Once you have completed the lab, select the **Check** button.

💡 Hints
===

- Remember that an aggregation pipeline must start with `db.<collection>.aggregate([])` in the MongoDB shell.
- Use the `$set` stage to add a new field with a value to each document.

🏁 Review and Solved Code
===

You can access the collection you want to use with dot notation:

```js
db.[[ Instruqt-Var key="BIRDS_COLLECTION_NAME" hostname="mongodb" ]]
```

Use the `aggregate` method to set up the aggregation pipeline.

We use the `$set` stage to add a new field to the documents in the collection. We add a field called `class` and set the value of that field to "bird".

```js,run
db.[[ Instruqt-Var key="BIRDS_COLLECTION_NAME" hostname="mongodb" ]].aggregate([
  {
    $set: {
      'class': 'bird'
    }
  }
])
```

## Solved Code

```js,run
db.[[ Instruqt-Var key="BIRDS_COLLECTION_NAME" hostname="mongodb" ]].aggregate([
  {
    $set: {
      'class': 'bird'
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
