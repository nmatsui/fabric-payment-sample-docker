#!/bin/bash
set -x

ORDERER_ADDRESS="orderer1:7050"
LOCALMSPID="Org1MSP"
PEER_MSPCONFIGPATH="/etc/hyperledger/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp"
CHAINCODE_SRC="github.com/nmatsui/fabric-payment-sample-chaincode"
CHAINCODE_VERSION="0.1"

docker stack rm ${STACK_NAME}
docker stack rm kafka
docker stack rm zookeeper

docker network rm fabric-sample-nw

docker network create --driver=overlay --attachable=true fabric-sample-nw

docker stack deploy zookeeper --compose-file zookeeper-compose.yaml

sleep 10

docker stack deploy kafka --compose-file kafka-compose.yaml

sleep 10

docker stack deploy ${STACK_NAME} --compose-file docker-compose.yaml

sleep 30

CLI=$(docker ps -f name=fabric-payment_cli -q)
API=$(docker ps -f name=fabric-payment_api0 -q)

setup_peer () {
  ## Join peer0 to the channel.
  docker exec -e "CORE_PEER_LOCALMSPID=${LOCALMSPID}" -e "CORE_PEER_MSPCONFIGPATH=${PEER_MSPCONFIGPATH}" -e "CORE_PEER_ADDRESS=${1}" ${CLI} peer channel join -b /etc/hyperledger/artifacts/${CHANNEL_NAME}.block

  ## Install chaincode to peer0
  docker exec -e "CORE_PEER_LOCALMSPID=${LOCALMSPID}" -e "CORE_PEER_MSPCONFIGPATH=${PEER_MSPCONFIGPATH}" -e "CORE_PEER_ADDRESS=${1}" ${CLI} peer chaincode install -n ${CHAINCODE_NAME} -p ${CHAINCODE_SRC} -v ${CHAINCODE_VERSION}
}

# Create the channel
docker exec -e "CORE_PEER_LOCALMSPID=${LOCALMSPID}" -e "CORE_PEER_MSPCONFIGPATH=${PEER_MSPCONFIGPATH}" ${CLI} peer channel create -o ${ORDERER_ADDRESS} -c ${CHANNEL_NAME} -f /etc/hyperledger/artifacts/channel.tx

sleep 10


# Setup peer
setup_peer "peer0:7051"

sleep 10

setup_peer "peer1:7051"

sleep 10

setup_peer "peer2:7051"

sleep 10

setup_peer "peer3:7051"

sleep 10

# Instantiate chaincode
PEER_ADDRESS="peer0:7051"

docker exec -e "CORE_PEER_LOCALMSPID=${LOCALMSPID}" -e "CORE_PEER_MSPCONFIGPATH=${PEER_MSPCONFIGPATH}" -e "CORE_PEER_ADDRESS=${PEER_ADDRESS}" ${CLI} peer chaincode instantiate -o ${ORDERER_ADDRESS} -C ${CHANNEL_NAME} -n ${CHAINCODE_NAME} -v ${CHAINCODE_VERSION} -c '{"Args":[""]}' -P "OR ('Org1MSP.member')"

# Generate CA admin & user
docker exec ${API} node ./scripts/enrollAdmin.js ${CA_PASSWORD}
docker exec ${API} node ./scripts/registerUser.js ${USER_NAME}
