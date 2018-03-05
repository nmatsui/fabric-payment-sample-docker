#!/bin/bash
set -x

ORDERER_ADDRESS="orderer:7050"
LOCALMSPID="Org1MSP"
PEER_MSPCONFIGPATH="/etc/hyperledger/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp"
CHAINCODE_SRC="github.com/nmatsui/fabric-payment-sample-chaincode"
CHAINCODE_VERSION="0.1"

CLI="cli"

docker-compose -f docker-compose.yaml down
docker network rm fabric-sample-nw

docker network create --driver=bridge --attachable=true fabric-sample-nw
docker-compose -f docker-compose.yaml up -d

sleep 10

# Create the channel
docker exec -e "CORE_PEER_LOCALMSPID=${LOCALMSPID}" -e "CORE_PEER_MSPCONFIGPATH=${PEER_MSPCONFIGPATH}" ${CLI} peer channel create -o ${ORDERER_ADDRESS} -c ${CHANNEL_NAME} -f /etc/hyperledger/artifacts/channel.tx

sleep 10

# peer0
PEER_ADDRESS="peer0:7051"

## Join peer0 to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=${LOCALMSPID}" -e "CORE_PEER_MSPCONFIGPATH=${PEER_MSPCONFIGPATH}" -e "CORE_PEER_ADDRESS=${PEER_ADDRESS}" ${CLI} peer channel join -b /etc/hyperledger/artifacts/${CHANNEL_NAME}.block

## Install chaincode to peer0
docker exec -e "CORE_PEER_LOCALMSPID=${LOCALMSPID}" -e "CORE_PEER_MSPCONFIGPATH=${PEER_MSPCONFIGPATH}" -e "CORE_PEER_ADDRESS=${PEER_ADDRESS}" ${CLI} peer chaincode install -n ${CHAINCODE_NAME} -p ${CHAINCODE_SRC} -v ${CHAINCODE_VERSION}


# Instantiate chaincode
PEER_ADDRESS="peer0:7051"

docker exec -e "CORE_PEER_LOCALMSPID=${LOCALMSPID}" -e "CORE_PEER_MSPCONFIGPATH=${PEER_MSPCONFIGPATH}" -e "CORE_PEER_ADDRESS=${PEER_ADDRESS}" ${CLI} peer chaincode instantiate -o ${ORDERER_ADDRESS} -C ${CHANNEL_NAME} -n ${CHAINCODE_NAME} -v ${CHAINCODE_VERSION} -c '{"Args":[""]}' -P "OR ('Org1MSP.member')"
