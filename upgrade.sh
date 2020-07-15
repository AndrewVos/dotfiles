#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

export UPGRADE="yes"
export LOG_FILE=$(mktemp)

function write-log {
  if [[ $? -gt 0 ]]; then
    echo "Install failed. Logs are here: $LOG_FILE"
  fi
}
trap write-log EXIT

echo "Upgrading packages..."
sudo apt update -y >> "$LOG_FILE" 2>&1
sudo apt upgrade -y >> "$LOG_FILE" 2>&1

for app in $(ls apps); do
  PREVIOUS_PWD="$(pwd)"
  cd $(mktemp -d)
  echo "Upgrading $app..."
  $PREVIOUS_PWD/apps/$app >> "$LOG_FILE" 2>&1
  cd "$PREVIOUS_PWD"
done
