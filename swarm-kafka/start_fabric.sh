#!/bin/bash
set -x

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
