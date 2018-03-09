# HowToStart Hyperledger/fabric network as solo

## get repository
1. clone this repository

    ```bash
    ~$ git clone https://github.com/nmatsui/fabric-payment-sample-docker.git
    ```

1. clone a sample REST API application respsitory

    ```bash
    ~$ git clone https://github.com/nmatsui/fabric-payment-sample-api.git
    ```

1. get a sample chaincode

    ```bash
    ~$ go get -u -d github.com/nmatsui/fabric-payment-sample-chaincode
    ```

## build REST API container image
1. change directory

   ```bash
   ~$ cd fabric-payment-sample-api/
   ```

1. generate new bearer token

    ```bash
    ~/fabric-payment-sample-api$ ./generate_token.sh
    ```

1. build docker image

    ```bash
    ~/fabric-payment-sample-api$ docker build -t fabric-payment/api .
    ```

## prepare Hyperledger/fabric network
1. change directory

   ```bash
   $ cd ../fabric-payment-sample-docker/dev-solo/
   ```

1. get Hyperledger/fabric 1.1

   ```bash
   ~/fabric-payment-sample-docker/dev-solo$ curl -sSL https://goo.gl/6wtTN5 | bash -s 1.1.0-rc1
   ```

1. set environment variables

    ```bash
    ~/fabric-payment-sample-docker/dev-solo$ source .env
    ~/fabric-payment-sample-docker/dev-solo$ export CA_ADMIN_PASSWORD=any_string_you_choose
    ```

1. generate artifacts

   ```bash
   ~/fabric-payment-sample-docker/dev-solo$ ./generate_artifact.sh ${CA_ADMIN_PASSWORD}
   ```

## start Hyperledger/fabric network
1. start network

    ```bash
    ~/fabric-payment-sample-docker/dev-solo$ ./start.sh
    ```

## terminate Hyperledger/fabric network
1. terminate network

    ```bash
    ~/fabric-payment-sample-docker/dev-solo$ ./terminate.sh
    ```
