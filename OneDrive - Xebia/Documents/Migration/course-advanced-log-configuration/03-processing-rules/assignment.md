---
slug: processing-rules
id: bd87g8rzdwbi
type: challenge
title: Processing Rules
notes:
- type: text
  contents: |
    # Processing Rules

    In this challenge, you'll configure the Datadog Agent to remove invalid characters from the `discounts` service logs.

    Click **Start** below when your environment is ready.

    > **Note**: This lab will timeout after 15 minutes of inactivity.
tabs:
- id: pa0suan8q3oy
  title: Terminal
  type: terminal
  hostname: lab-host
- id: 6hvamxpxaba1
  title: IDE
  type: service
  hostname: lab-host
  path: /
  port: 8080
- id: nyqs6eccjgz2
  title: Storedog
  type: website
  url: https://lab-host.${_SANDBOX_ID}.instruqt.io
  new_window: true
- id: qljuehru7wx1
  title: Help
  type: website
  url: https://datadoghq.dev/training-lab-support?tags=lc-env
difficulty: basic
enhanced_loading: null
---

You've made a lot of progress with the Storedog application logs. However, there are some invalid characters to fix.

Explore the existing logs
===
1. Move to the **Logs** tab in Datadog.
1. Filter the logs by the `discounts` service.
1. You'll see that some logs are coming in with invalid characters such as `"[37m]"`.

![The discounts service logs contain invalid characters](..\assets\invalid_characters.png)

These characters come from developers adding color to the logs. These colors appear in the terminal but in Datadog, they show up a garbled characters.

![The logs appear with color in the terminal](..\assets\colored_terminal.png)

You're trying to keep the colors in the terminal, but not have them appear in Datadog. You can do this with processing rules.

Adding a service specific processing rule
===

Since only `discounts` logs have these characters, you can add a processing rule to only that service.

1. Open the `docker-compose.yml` file in the IDE.

1. Replace the `log_processing_rules` in the `discounts` service with the following:

    ```yaml
          "log_processing_rules": [
              {
                "type": "multi_line",
                "name": "combine_multiline_queries",
                "pattern": "^\\d+-\\d+-\\d+T\\d+:\\d+:\\d+(\\.\\d+)?(Z\\d*:?\\d*)?"
              },
              {
                "type": "mask_sequences",
                "name": "remove_invalid_characters",
                "replace_placeholder": "",
                "pattern": "(\\x9B|\\x1B\\[)[0-?]*[ -\\/]*[@-~]"
              }
            ]
    ```

    Here you are defining a rule based around a regular expression pattern. The pattern, defined as `(\\x9B|\\x1B\\[)[0-?]*[ -\\/]*[@-~]`, matches the kinds of color codes in Python logs, such as `"[37m]"`. The `replace_placeholder` is set to an empty string, this rule indicates to the Agent that any log characters matching the pattern should be taken out and not replaced with any characters.

1. In the **Terminal** tab, restart the discounts service with the following commands to apply the changes:

    ```bash,run
    docker compose down discounts
    docker compose up discounts -d
    ```

View the results
===

1. Return to the **[Log Explorer](https://app.datadoghq.com/logs)** page in Datadog.

1. Filter the logs by the `discounts` service.

1. You'll see that the logs are now coming in without garbled characters.

![There are now aggregated logs without invalid characters](..\assets\valid_characters.png)

Adding a global processing rule
===

Global processing rules are often used for scrubbing sensitive data. Right now, you are able to see IP addresses in several logs. For example in the `nginx` service logs, you see the following:

![Some logs contain IP addresses](..\assets\nginx_no_rules.png)

You can see these by filtering the logs by the `store-nginx` service and looking for IP addresses.

Your company has created a mandate to redact any IP addresses from Datadog logs.

To comply, you can add a global processing rule to redact IP addresses across all services.

1. In the **IDE** tab, open the `docker-compose.yml` file.

1. In the `dd-agent` service section of the `docker-compose.yml`, add the following environment variable:

    ```yml
    DD_LOGS_CONFIG_PROCESSING_RULES=[{"type":"mask_sequences","name":"mask_ip_address", "replace_placeholder":"[IP REDACTED]","pattern" :"(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"}]
    ```

    This replaces any IP address pattern with the string `"[IP REDACTED]"`.

1. In the **Terminal** tab, restart the Datadog Agent to apply the changes by running the following commands:

    ```bash,run
    docker compose down dd-agent
    docker compose up dd-agent -d
    ```

1. Navigate to the **Logs** tab in Datadog.

1. Filter the logs by the `store-nginx` service.

1. After a few minutes, you'll see that the IP addresses are now redacted. You can also see redacted IP addresses in other services, such as `puppeteer`.

![IP addresses are now redacted](..\assets\redacted_ip.png)

> [!NOTE]
> Redacting the IP addresses from the `nginx` service may result in some log attributes being removed. To fix this you may need to adjust that service's log pipeline. You can learn more about this in the [Log Pipeline course](https://learn.datadoghq.com/courses/log-pipelines).

Activity summary
===

You've now learned to apply processing rules at the service and global level. You've removed invalid characters from the `discounts` service logs and redacted IP addresses from all logs.

Click **Next** to move on to the next activity.
