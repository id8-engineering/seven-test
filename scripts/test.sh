#!/usr/bin/env bash

# Copyright (c) 2026 ID8 Engineering AB
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

MODEM_FIRMWARE="firmware/mfw_nrf91x1_2.0.4.zip"
MODEM_FIRMWARE_URL="https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/sip/nrf91x1-sip/nrf91x1-lte-modem-firmware/mfw_nrf91x1_2.0.4.zip"

status() {
  printf '\033[1;36m%s\033[0m\n' "$1"
}

status "Creating Python virtual environment"
python3 -m venv .venv

status "Installing Python dependencies"
.venv/bin/pip install -r requirements.txt

mkdir -p firmware

if [[ -f "$MODEM_FIRMWARE" ]]; then
  status "Using existing modem firmware"
else
  status "Downloading modem firmware"
  curl -fL "$MODEM_FIRMWARE_URL" -o "$MODEM_FIRMWARE"
fi

status "Flashing modem firmware"
.venv/bin/pyocd cmd -t nrf91 -f 100000 \
  -c "nrf91-update-modem-fw -f $MODEM_FIRMWARE"
