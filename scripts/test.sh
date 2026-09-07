#!/usr/bin/env bash

# Copyright (c) 2026 ID8 Engineering AB
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

if [[ $# -lt 2 || "$1" != "--version" ]]; then
  printf 'Please select a tag release with --version <version>\n' >&2
  exit 1
fi

VERSION="$2"

ARCHIVE="seven-test-$VERSION.zip"
ARCHIVE_URL="https://github.com/id8-engineering/seven-test/releases/download/$VERSION/$ARCHIVE"
PACKAGE_DIR="seven-test-$VERSION"
MODEM_FIRMWARE="$PACKAGE_DIR/firmware/mfw_nrf91x1_2.0.4.zip"
TEST_FIRMWARE="$PACKAGE_DIR/seven-test.hex"
REQUIREMENTS="$PACKAGE_DIR/requirements.txt"
SERIAL_DEVICE_PATTERN="usb-Raspberry_Pi_Debug_Probe_*-if01"
SERIAL_PORT="$(find /dev/serial/by-id -maxdepth 1 -type l \
  -name "$SERIAL_DEVICE_PATTERN" -print -quit 2>/dev/null || true)"
TEST_TIMEOUT=660

status() {
  printf '\033[1;36m%s\033[0m\n' "$1"
}

status "Running Seven Test version $VERSION"

if [[ -z "$SERIAL_PORT" ]]; then
  printf 'Raspberry Pi Debug Probe UART not found\n' >&2
  exit 1
fi

if [[ ! -f "$ARCHIVE" ]]; then
  status "Downloading Seven Test $VERSION"
  curl -fL "$ARCHIVE_URL" -o "$ARCHIVE"
fi

if [[ ! -f "$TEST_FIRMWARE" || ! -f "$MODEM_FIRMWARE" || ! -f "$REQUIREMENTS" ]]; then
  status "Extracting Seven Test $VERSION"
  unzip -oq "$ARCHIVE" -d "$PACKAGE_DIR"
fi

status "Creating Python virtual environment"
python3 -m venv .venv

status "Installing Python dependencies"
.venv/bin/pip install -r "$REQUIREMENTS"

status "Flashing modem firmware"
.venv/bin/pyocd cmd -t nrf91 -f 100000 -O auto_unlock \
  -c "nrf91-update-modem-fw -f $MODEM_FIRMWARE"

status "Using Seven Test $VERSION"

status "Opening $SERIAL_PORT"
stty -F "$SERIAL_PORT" 115200 raw -echo
exec 3<>"$SERIAL_PORT"

status "Flashing Seven Test $VERSION"
probe-rs download --chip nRF9151_xxAA --speed 100 --allow-erase-all \
  --binary-format hex "$TEST_FIRMWARE"

status "Resetting Seven"
probe-rs reset --chip nRF9151_xxAA --speed 100

status "Running tests"
sleep 1
printf 'ztest run-all\r' >&3

while IFS= read -r -t "$TEST_TIMEOUT" line <&3; do
  printf '%s\n' "$line"

  if [[ "$line" == *"PROJECT EXECUTION SUCCESSFUL"* ]]; then
    status "Seven Test passed"
    exit 0
  fi

  if [[ "$line" == *"PROJECT EXECUTION FAILED"* ]]; then
    status "Seven Test failed"
    exit 1
  fi
done

status "Seven Test timed out"
exit 1
