# Seven test

## Prerequisites

* [Raspberry Pi Debug Probe](https://www.electrokit.com/raspberry-pi-debug-probe.)

Install the required Ubuntu packages:

```bash
sudo apt update
sudo apt install curl python3 python3-venv unzip
```

Install probe-rs:

```bash
curl --proto '=https' --tlsv1.2 -LsSf https://github.com/probe-rs/probe-rs/releases/latest/download/probe-rs-tools-installer.sh | sh
```

## Connect Seven

Before running the tests, connect Seven to the Raspberry Pi Debug Probe and external power supply
as shown below.

![Seven test connection schematic](assets/seven-test-connection-schematic.drawio.svg)

## Run tests

Run the complete Seven test:

```bash
bash -c 'VERSION=v0.0.4; mkdir -p "$HOME/seven-test" && cd "$HOME/seven-test" && curl -fL "https://github.com/id8-engineering/seven-test/releases/download/$VERSION/seven-test-$VERSION.zip" -o seven-test.zip && unzip -o seven-test.zip && chmod +x test.sh && ./test.sh --version "$VERSION"'
```

## Develop

See [DEVELOPMENT.md](DEVELOPMENT.md) to set up the development environment and build on Seven Test.
