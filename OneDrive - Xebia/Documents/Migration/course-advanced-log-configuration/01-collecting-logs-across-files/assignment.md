---
slug: collecting-logs-across-files
id: mojdp2i4nrqe
type: challenge
title: Collecting Logs Across Files
notes:
- type: text
  contents: |
    # Collecting Logs Across Files

    In this activity you'll configure the Datadog Agent to collect logs from multiple files in the `database` service.

    Click **Start** below when your environment is ready.

    > **Note**: This lab will timeout after 15 minutes of inactivity.
tabs:
- id: z6cobjgxik3l
  title: Terminal
  type: terminal
  hostname: lab-host
- id: yyngsvmv6gca
  title: IDE
  type: service
  hostname: lab-host
  path: /
  port: 8080
- id: 9it3o112eegz
  title: Storedog
  type: website
  url: https://lab-host.${_SANDBOX_ID}.instruqt.io
  new_window: true
- id: jltoliztyigf
  title: Help
  type: website
  url: https://datadoghq.dev/training-lab-support?tags=lc-env
difficulty: basic
enhanced_loading: null
---

In this lab, you'll be working with the Storedog application. Storedog is an e-commerce application that allows users to search, view, and purchase products. The application is composed of a web frontend, a backend server with several supporting services, and two PostgreSQL databases.

Storedog already has a basic log setup, but there are some problems:

- Logs aren't coming from the `database` service after startup
- The `discounts` service logs are being broken up into too many events
- Some logs are noisy and don't need to be stored

You've been tasked with diagnosing the source of these problems and fixing them.

View the current state of logs
===

Get started by looking at the current state of the Postgres logs.

1. [Log in to Datadog](https://app.datadoghq.com/account/login) using the account credentials displayed in the terminal. You can run `show-dd-credentials` in the lab terminal to retrieve your training account credentials.

1.  In the main menu, click **Logs** to navigate to [Log Explorer](https://app.datadoghq.com/logs).

    > [!NOTE]
    > If you see the message, "Get started with Log Management to correlate logs with traces", click it to enable logging.

1. In the time picker, set the time range to `Past 15 min`.

1. Throughout this lab, consider removing several columns from the Logs Explorer other than **Content**. This will make the log changes more visible.

    ![A dropdown for a column which includes the option to remove it](..\assets\remove_column.png)

    Remove columns by clicking on their arrow dropdown, then clicking "Remove".

1. In the facets list, click the `Service` facet group to expand it and then click `database`. You'll see only the `database` service logs.

  Beyond the startup logs, there are no logs from the Postgres service.

  ![Selecting the postgres service logs only consists of startup messages](..\assets\database_no_logs.png)

Datadog isn't configured for reading from the `database` log files. This is indicated by the log stating that `Future log output will appear in directory "/var/log/pg_log"`.

Collect logs from Postgres files
===

By default, Datadog doesn't collect logs from a file. Datadog needs to know the location where logs are stored. You can configure this by doing the following:

1. Open `docker-compose.yml` in the IDE.

1. In the `postgres` service configuration there is a line configuring `com.datadoghq.ad.logs`:

    ```yml
    '[{"source": "postgresql", "service": "database"}]'`
    ```

1. Replace that line with the following:

      ```yml
        '[{ "service": "database", "source": "postgresql", "type": "file", "path": "/var/log/pg_log/postgresql.json"}]'
      ```

  The configuration now has a file name to collect from. But there isn't only one file, the service rotates the logs into different files.

  A list of the files in that directory might look like this:
  - `/var/log/postgresql/postgresql-1.json`
  - `/var/log/postgresql/postgresql-2.json`
  - `/var/log/postgresql/postgresql-3json`

  You can use a wildcard `*` to collect from all files in the directory.

1. Update the `path` to the following:

   `"path": "/var/log/pg_log/postgresql*.json"`

1. To apply the changes, run the following command in the **Terminal** tab:

    ```bash,run
    docker compose down postgres
    docker compose up postgres -d
    ```

View the results
===

1. Return to Datadog and navigate to the **Logs** page. Make sure to filter by the `service:database` facet to retrieve only the `database` logs.

1. You should now see logs from the `database` service.

  ![Logs from the database service are now visible](..\assets\database_with_logs.png)

Activity summary
===

In this challenge you used the `file` configuration option and the wildcard operator `*`. Now you're collecting from many files in the `database` service.

Click **Next** to move on to the next activity.
