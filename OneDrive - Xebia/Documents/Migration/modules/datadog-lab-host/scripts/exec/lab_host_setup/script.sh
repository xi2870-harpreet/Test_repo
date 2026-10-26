#!/bin/bash
# SECURITY NOTE: The original Datadog track_scripts/setup-lab-host scripts use
# `set -x` for debugging but also pass LEARNING_CENTER_API_ACCESS_TOKEN as a
# command-line argument to `lc-env config --secret ...`. With `set -x` active,
# this leaks the token to logs. When porting that logic here:
#   1. Do NOT use `set -x` globally; if tracing is needed, wrap only non-secret lines.
#   2. Pass the token via env var (already done via exec.environment above), not CLI.
#   3. After lc-env init completes, unset LEARNING_CENTER_API_ACCESS_TOKEN so it
#      is no longer present for the duration of the lab session.
#
# PLACEHOLDER: Adapt the original track_scripts/setup-lab-host logic here.
# The original script:
# 1. Downloads lab files from GCP: learning-center-files/${TRACK_SLUG}.tar
# 2. Installs lc-env from ${LEARNING_CENTER_ASSETS_URL}/lc-cli/v1/latest/lc-env-linux-amd64
# 3. Calls: lc-env config --secret ... --lc-user-id ... --lc-api-url ...
# 4. Calls: lc-env init user --quiet
# 5. Exports DD_API_KEY, DD_APP_KEY, DD_SITE to .bashrc
# 6. Starts docker-compose services (Storedog, Agent, etc.)
#
# All of these steps assume a GCP-hosted VM with Docker pre-installed.
# Once a container image is available, port this logic to run inside the container.
echo "datadog-lab-host setup placeholder"
