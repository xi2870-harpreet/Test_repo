---
slug: filtering-logs
id: 5hc3ela2lg7z
type: challenge
title: Filtering Logs
notes:
- type: text
  contents: |
    # Filtering Logs

    In this challenge you'll configure the Datadog Agent to restrict logs collected from `nginx`.

    Click **Start** below when your environment is ready.

    > **Note**: This lab will timeout after 15 minutes of inactivity.
tabs:
- id: j50npszx4q3e
  title: Terminal
  type: terminal
  hostname: lab-host
- id: 4x0leh63md5h
  title: IDE
  type: service
  hostname: lab-host
  path: /
  port: 8080
- id: 67zj0vgvyaob
  title: Storedog
  type: website
  url: https://lab-host.${_SANDBOX_ID}.instruqt.io
  new_window: true
- id: ai0m2e7ew0uq
  title: Help
  type: website
  url: https://datadoghq.dev/training-lab-support?tags=lc-env
difficulty: basic
enhanced_loading: null
---

In this challenge, you'll filter out logs that you don't need Datadog to ingest and index.

View the current state of logs
===

1.  In the main menu, click **Logs** to navigate to [Log Explorer](https://app.datadoghq.com/logs).

1. In the time picker, set the time range to `Past 15 min`.

1. In the facets list, click the `Service` facet group to expand it and then click `store-nginx`.

  There are many `store-nginx` service logs fetching different resources.

  ![Logs from fetching api/pages and api/products as well as other requests](..\assets\nginx_no_rules.png)

Filtering with exclude
===

Many of these logs are requests for images. You've decided you don't need them.

1. Open the `docker-compose.yaml` file in the IDE.
1. Under `labels` in the `nginx` section, change the `com.datadoghq.ad.logs:` section to the following:

    ```yml
      com.datadoghq.ad.logs: '[{
        "source": "nginx",
        "service": "store-nginx",
        "log_processing_rules": [
          {
            "type": "exclude_at_match",
            "name": "no_images",
            "pattern": ".*GET /_next/image.*"
          }
        ]
        }]'
    ```

    Now, you've excluded any logs about fetching images from the `store-nginx` service.

1. Restart the Datadog Agent to apply the changes:

    ```bash, run
    docker compose down dd-agent
    docker compose up dd-agent -d
    ```

1. Return to the **Logs** tab in Datadog. You'll see that image request logs are no longer coming in.

    ![No image requests from store-nginx appear in the Log Explorer](..\assets\nginx_no_images.png)

Filtering with include
===

You decided to go in the opposite direction and only **include** logs that request images.

1. Open `docker-compose.yml` in the IDE.

1. Under `labels` in the `nginx` section, change the `com.datadoghq.ad.logs:` section to the following:

    ```yml
      com.datadoghq.ad.logs: '[{
        "source": "nginx",
        "service": "store-nginx",
        "log_processing_rules": [
          {
            "type": "include_at_match",
            "name": "only_images",
            "pattern": ".*GET /_next/image.*"
          }
        ]
        }]'
    ```

    Now, you've included only logs about fetching images from the `nginx` service.

1. Restart the Datadog Agent to apply the changes:

    ```bash, run
    docker compose down nginx
    docker compose up nginx -d
    ```

View the results
===

1. Return to the **Logs** tab in Datadog.
1. You'll see that only the logs from `nginx` requesting images are coming in.

![Now only logs requesting images appear in the Log Explorer](..\assets\nginx_only_images.png)


Lab conclusion
==============

Congratulations! You've learned how to apply configuration options to logs in Datadog. These include the following:

- Gathering logs across files using wildcards
- Aggregating multiline logs into single log events
- Applying processing rules at the local/service or global level
- Filtering logs using inclusion or exclusion

You can now apply these techniques to your own applications.

When you're done, click **Next**.
