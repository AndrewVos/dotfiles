#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo systemctl enable ly.service
