# fabric-payment-sample-docker
## Description
This project provides the configuration files to start Hyperledger/fabric 1.1 on docker.

- ./dev-solo
  - start Hyperledger/fabric network on single docker using docker-compose.
- ./swarm-kafka
  - start distributed Hyperledger/fabric network on docker cluster using docker swarm mode.

## See also
[fabric-payment-sample-chaincode](https://github.com/nmatsui/fabric-payment-sample-chaincode)  
[fabric-payment-sample-api](https://github.com/nmatsui/fabric-payment-sample-api)

## Requirement

||version|
|:--|:--|
|docker|17.12.1-ce|
|docer-compose|1.19.0|
|Hyperledger/fabric|1.1.0-rc1|

## How to start

- ./dev-solo
    - see [./dev-solo/HowToStart.md](/dev-solo/HowToStart.md)
- ./swarm-kafka
    - see [./swarm-kafka/HowToStart.md](/swarm-kafka/HowToStart.md)

## Contribution
1. Fork this project ( https://github.com/nmatsui/fabric-payment-sample-docker )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License
[Apache License, Version 2.0](/LICENSE)

## Copyright
Copyright (c) 2018 Nobuyuki Matsui <nobuyuki.matsui@gmail.com>
