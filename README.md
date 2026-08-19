# Seven test

![Seven test connection schematic](assets/seven-test-connection-schematic.drawio.svg)

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

The tested and verified development platforms are:

- Ubuntu 26.04
- macOS 26.5

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

<details>
<summary>Linux</summary>

```text
(v3.4.0) [user@host ~]$
```

</details>

<details>
<summary>macOS</summary>

```text
(v3.4.0) hostname%
```

</details>

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

## Build

Build Seven Test for Seven:

```bash
west build -p always -b seven/nrf9151/ns app
```

## Flash

Flash Seven:

```bash
west flash
```

## Monitor test results

Open the UART serial port at 115200 baud:

```bash
minicom -D /dev/ttyACM0 -b 115200 # Linux
minicom -D /dev/cu.usbmodemXXXX -b 115200 # macOS
```

Reset Seven to run the tests and display the results.
