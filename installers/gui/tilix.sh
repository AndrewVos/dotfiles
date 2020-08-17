#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo sed -i 's/^.*Icon=com.gexperts.Tilix.*$/Icon=org.gnome.Terminal/' /usr/share/applications/com.gexperts.Tilix.desktop
