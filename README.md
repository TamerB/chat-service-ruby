# Chat Service DB Write Ruby

## Overview
This service provides a REST API in which users can control applications, applications chats, and chat messages. It forwards user requests to [chat-reader service](https://github.com/TamerB/chat-service-db-reader-ruby) and [chat-writer service](https://github.com/TamerB/chat-service-db-write-ruby) using RabitMQ (RPC requests) and reply to users according to the responses it gets from the two services.

This service has the following API endpoints:
```
/readyz                                                         GET
/healthz                                                        GET

/applications/{name}                                            POST
/applications/{token}                                           PUT
/applications/{token}                                           GET

/applications/{token}/chats                                     POST
/applications/{token}/chats/{number}                            GET

/applications/{token}/chats/{number}/messages                   POST
/applications/{token}/chats/{number}/messages/{number}          PUT
/applications/{token}/chats/{number}/messages                   GET
/applications/{token}/chats/{number}/messages/{number}          GET

/applications/{token}/chats/{number}/search/{phrase}            GET
```

## Developer setup
#### Setup locally
This service uses Ruby version ruby-3.1.3.
From the project's root directory:

```
# to install ruby and set gemset using rvm
rvm use --create ruby-3.1.3-rvm@chat-master
bundle # to install required gems
# to create database (required if database doesn't exist)
rake db:create # or rails db:create
# to make migrations (reqired if there're missing migrations in database)
rake db:migrate # or rails db:migrate
```

## Running locally

```bash
#!/bin/sh

export PORT=<e.g. 3000>
export MQ_HOST=<e.g. 127.0.0.1>

rails s
```

### Environment Variables
#### `PORT`
Ports which the service will be listening on to `http` requests.
#### `MQ_HOST`
RabbitMQ host

## Build Docker image
```
docker build -t chat-master:latest .
```

## Test
To run tests, from the project's root directory, run `rails test ./...` in terminal.


## docker-compose
To start all services using docker-compose run `./build.sh`. To stop them run `./stop.sh`

## Important notes
- `build.sh` and `stop.sh` delete MySQL data when executed. To avoid this action, please comment the following lines in `build.sh` and `stop.sh`:
```
sudo rm -rf ./db/master/data/*
sudo rm -rf ./db/slave/data/*
```
- This service uses MySQL for development and production. And uses Sqlite for testing.
- When testing this service, you will need to run [chat-reader service](https://github.com/TamerB/chat-service-db-reader-ruby) and [chat-writer service](https://github.com/TamerB/chat-service-db-write-ruby). Please make sure to use a testing MySQL database in production or use Sqlite by modifying `config/database.yml` in both services.