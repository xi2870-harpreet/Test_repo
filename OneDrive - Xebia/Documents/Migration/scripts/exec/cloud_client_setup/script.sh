#!/bin/sh
# Mirrors the legacy track_scripts/setup-cloud-client
aws configure set region eu-west-2 --profile default
aws ec2 create-default-vpc || true
