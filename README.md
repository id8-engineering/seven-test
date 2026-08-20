# Seven test

## Connect Seven

Before running the tests, connect Seven to the Raspberry Pi Debug Probe and external power supply
as shown below.

![Seven test connection schematic](assets/seven-test-connection-schematic.drawio.svg)

## Run tests

Run the complete Seven test:

```bash
mkdir -p ~/seven-test
cd ~/seven-test

curl -fLO https://raw.githubusercontent.com/id8-engineering/seven-test/v1.0.0/scripts/test.sh
curl -fLO https://raw.githubusercontent.com/id8-engineering/seven-test/v1.0.0/requirements.txt

chmod +x test.sh
./test.sh
```

## Develop

See [DEVELOPMENT.md](DEVELOPMENT.md) to set up the development environment and build on Seven Test.
