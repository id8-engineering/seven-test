# Development

This guide collects the hardware, tools, and workspace setup needed before building and running
Seven Test. Follow it once on a new development machine.

## Required hardware and software

You need a Raspberry Pi Debug Probe to flash Seven over SWD and read test output over UART. You
also need nRF Util to install and use the nRF Connect SDK.

- [Raspberry Pi Debug Probe](https://www.electrokit.com/raspberry-pi-debug-probe)
- Install [nRF Util](https://docs.nordicsemi.com/bundle/nrfutil/page/guides/installing.html)

> [!NOTE]
> Follow Nordic's prerequisites when installing nRF Util.

Connect the Raspberry Pi Debug Probe to Seven using `DEBUG` for flashing and `UART` for test
output. Seven must also be connected to an external power supply.

> [!NOTE]
> Seven supports a 6-36 V power supply. It is also possible to power it with 5 V through the power
> supply connector.

### Supported platforms

The tested and verified development platform is Ubuntu 26.04.

## Setup nRF Connect development environment

Install nRF Connect SDK manager:

```bash
nrfutil install sdk-manager
```

Install nRF Connect SDK:

```bash
nrfutil sdk-manager install v3.4.0
```

Start the nRF Connect SDK toolchain shell:

```bash
nrfutil sdk-manager toolchain launch --ncs-version v3.4.0 --shell
```

If the command succeeds, your shell prompt will change to something like:

```text
(v3.4.0) [user@host ~]$
```

All remaining commands in this guide should be run inside the `nrfutil` shell.

## Set up workspace

Create a new workspace and enter it:

```bash
mkdir -p ~/src/seven-test-workspace
cd ~/src/seven-test-workspace
```

Initialize the workspace:

```bash
west init -m https://github.com/id8-engineering/seven-test --mr main .
```

Change into the project directory:

```bash
cd seven-test
```

Fetch and check out sources:

```bash
west update
```

Now your workspace is ready.

## Run tests

Twister builds the test firmware, flashes Seven, monitors the test output, and writes the test
reports.

```bash
west twister -T tests -p seven/nrf9151/ns \
  --device-testing --device-serial /dev/ttyACM0
```
