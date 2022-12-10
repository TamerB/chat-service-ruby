# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [UNRELEASED] - 0000-00-00

## [0.1.0] - 2022-12-10
### Added
- Add endpoints, controllers, RabbitMQ handlers (RPC client), and unit tests for:
    * Applications create, update, and show.
    * Applications chats create, update, list, and show.
    * Applications chats messages create, update, list, show, and search.
- Add pagination to Applications chats list, and to Applications chats messages list and search.
- Add swagger documenation.
- Add Dockerfile.
- Add docker-compose for master, reader slave, writer slave, MySQL, RabbitMQ, Redis, and Elasticsearch.