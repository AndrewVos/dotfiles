#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

asdf plugin add ruby ||:
asdf install ruby 2.7.1 ||:

asdf plugin add nodejs 14.9.0 ||:
NODEJS_CHECK_SIGNATURES=no asdf install nodejs latest ||:
