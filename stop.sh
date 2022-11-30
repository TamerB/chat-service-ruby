#!/bin/bash

docker-compose down -v --remove-orphans
# sudo rm -rf ./docker-compose/db/master/data/*
# sudo rm -rf ./docker-compose/db/slave/data/*