#!/bin/bash

# Copy Cowrie log from Docker container to host path
docker cp docker_cowrie_1:/cowrie/cowrie-git/var/log/cowrie/cowrie.json /opt/cowrie/var/log/cowrie/cowrie.json
