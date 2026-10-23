🚀 Let's start
==============

## Login to AWS

Use the credentials displayed in the **AWS Console** tab.

- Navigate to **Services → EC2 → Instances**

🏁 Finish
=========

## Terminate the instance you created.

Select the instance, choose **Instance State → Terminate instance**, and confirm.

> **Tip:** If the Console is unavailable, use the **Cloud CLI** tab instead:
> ```
> aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances \
>   --query 'Reservations[*].Instances[*].InstanceId' --output text)
> ```

To complete this challenge, press **Check**.
