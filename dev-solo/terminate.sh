#!/bin/bash
set -x

docker-compose -f docker-compose.yaml kill
docker-compose -f docker-compose.yaml down

docker rm -f $(docker ps -aq)
docker rmi $(docker images dev-* -q)

docker network rm fabric-sample-nw
docker volume prune -f
