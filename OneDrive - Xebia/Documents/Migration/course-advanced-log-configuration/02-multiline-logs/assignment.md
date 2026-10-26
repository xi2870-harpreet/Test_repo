---
slug: multiline-logs
id: bnfgr3pg8xbj
type: challenge
title: Aggregating Multiline Logs
notes:
- type: text
  contents: |
    # Aggregating Multiline Logs

    In this challenge you'll configure the Datadog Agent to aggregate multiline logs.

    Click **Start** below when your environment is ready.

    > **Note**: This lab will timeout after 15 minutes of inactivity.
tabs:
- id: 09yoy3puca1m
  title: Terminal
  type: terminal
  hostname: lab-host
- id: ty7herbcdfis
  title: IDE
  type: service
  hostname: lab-host
  path: /
  port: 8080
- id: j0mo3ysn8mhb
  title: Storedog
  type: website
  url: https://lab-host.${_SANDBOX_ID}.instruqt.io
  new_window: true
- id: wh5ssiwpyjc5
  title: Help
  type: website
  url: https://datadoghq.dev/training-lab-support?tags=lc-env
difficulty: basic
enhanced_loading: null
---

You're now collecting logs from the `database` service, but the `discounts` service is still having problems.

View the current state of logs
===

1. In Datadog, navigate to the **Logs** page and filter by the `service:store-discounts` facet.

1. You'll see that many logs appear fragmented.

![Many Python logs incorrectly consist of only a word or a few characters](..\assets\multiline_fragmented.png)

You'll fix this issue by configuring Datadog to aggregate multiline logs for the `discounts` service.

Fixing multiline logs
===

Next, you'll use the `pattern` option to match the start of a new log event. The logs start with a date, which you can use for the pattern.

1. Open the `docker-compose.yaml` file in the IDE.

1. Under the `discounts` service definition, find the label `com.datadoghq.ad.logs` and update it to look like the following:

    ```yml
        com.datadoghq.ad.logs: '[
          {
            "source": "python",
            "service": "store-discounts",
            "log_processing_rules": [
              {
                "type": "multi_line",
                "name": "combine_multiline_queries",
                "pattern": "^\\d+-\\d+-\\d+T\\d+:\\d+:\\d+(\\.\\d+)?(Z\\d*:?\\d*)?"
              }
            ]
          }]'
    ```

    This indicates to the Datadog Agent that new logs start with a timestamp represented by the `pattern`. The Agent will add each line of a log into a single event until it reaches the pattern again.

1. Now, restart the `discounts` service to apply the changes:

    ```bash
    docker compose down discounts
    docker compose up discounts -d
    ```

View the results
===

1. In Datadog, navigate to the **Logs** page and filter by the `service:store-discounts` facet.

1. With the multiline logs fixed, you should now see full statements as a single log event.

![Logs have been grouped into readable messages](..\assets\multiline_aggreggated.png)

    You may have noticed that there are some strange characters in the logs. These will be fixed in the next activity.

Activity summary
===

The logs for the `store-discounts` service are much clearer now. You aggregated the logs that use multiple lines using patterns that match the beginning of a line. Next, you'll clean up the logs by removing invalid characters.

Click **Next** to move on to the next activity.
