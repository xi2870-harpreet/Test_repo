---
slug: aws-ec2-create
id: p3umgqiibs5w
type: challenge
title: Create an AWS EC2 instance
teaser: Every cloud starts from VM
notes:
- type: text
  contents: |-
    You're about to create an EC2 instance using AWS CLI.

    Please wait while we provision the AWS account.
tabs:
- id: j1ruaxdzatx2
  title: Cloud CLI
  type: terminal
  hostname: cloud-client
- id: mi9yzuxters8
  title: AWS Console
  type: service
  hostname: cloud-client
  path: /
  port: 80
- id: q7vpdcqcvl9b
  title: Ubuntu
  type: terminal
  hostname: ubuntu
- id: 2tau9ccy6ahy
  title: Test
  type: service
  hostname: cloud-client
  path: /
  port: 8501
difficulty: basic
timelimit: 600
enhanced_loading: null
---

👋 Introduction
===============

Use the terminal to create EC2 instance:

```
aws ec2 run-instances --image-id ami-01685d240b8fbbfeb --instance-type t2.nano
```

To complete this challenge, press **Check**.
