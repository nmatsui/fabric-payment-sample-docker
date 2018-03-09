# HowToStart Hyperledger/fabric network as distributed using kafka

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

## start docker swarm cluster
1. start swarm cluster at node0

    ```bash
    ~$ docker swarm init --advertise-addr 192.168.100.10
    ```
    * `192.168.100.10` is the IP Address of node0 which is reachable to node1, node2, node3

1. show command string to join swarm cluster as master node

    ```bash
    ~$ docker swarm join-token manager
    ```

1. join swarm cluster as master at node1, node2 and node3 using above command

1. add label to nodes

    ```bash
    ~$ docker node update --label-add type=node0 <<id_of_node0>>
    ~$ docker node update --label-add type=node1 <<id_of_node1>>
    ~$ docker node update --label-add type=node2 <<id_of_node2>>
    ~$ docker node update --label-add type=node3 <<id_of_node3>>
    ```

## start local registry
1. start local registry on swarm cluster

    ```bash
    ~$ docker service create --name registry --publish 5000:5000 registry:2
    ```

## start nfs server
1. start nfs server at node0
1. install nfs client library at node1, node2, node3

## prepare Hyperledger/fabric network
1. change directory

   ```bash
   $ cd ../fabric-payment-sample-docker/swarm-kafka/
   ```

1. get Hyperledger/fabric 1.1

   ```bash
   ~/fabric-payment-sample-docker/swarm-kafka$ curl -sSL https://goo.gl/6wtTN5 | bash -s 1.1.0-rc1
   ```

1. set environment variables

    ```bash
    ~/fabric-payment-sample-docker/swarm-kafka$ source .env
    ~/fabric-payment-sample-docker/swarm-kafka$ export CA_ADMIN_PASSWORD=any_string_you_choose
    ```

1. generate artifacts

    ```bash
    ~/fabric-payment-sample-docker/swarm-kafka$ ./generate_artifact.sh ${CA_ADMIN_PASSWORD} <<IPAddress_of_nfs_server>> <<shared_nfs_directory>>
    ```

## start Hyperledger/fabric network
1. start network

    ```bash
    ~/fabric-payment-sample-docker/swarm-kafka$ ./start_fabric.sh
    ```

1. wait untile all containers are running

1. setup Hyperledger/fabric network

    ```bash
    ~/fabric-payment-sample-docker/swarm-kafka$ ./setup_fabric.sh
    ```

## terminate Hyperledger/fabric network
1. terminate network

    ```bash
    ~/fabric-payment-sample-docker/swarm-kafka$ ./terminate.sh ${CA_ADMIN_PASSWORD} <<IPAddress_of_nfs_server>> <<shared_nfs_directory>>
    ```
