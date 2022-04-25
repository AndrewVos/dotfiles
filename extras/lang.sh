#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

asdf plugin add ruby ||:
asdf plugin add nodejs ||:
