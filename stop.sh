#!/bin/bash

docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
docker-compose down -v --remove-orphans
sudo rm -rf ./docker-compose/db/master/data/*
sudo rm -rf ./docker-compose/db/slave/data/*