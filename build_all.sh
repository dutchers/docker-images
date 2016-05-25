#!/bin/bash

# Update all the docker images.
# This script pulls the latest debian.  Builds base-machine and then builds all the images that
# extend base-machine. It should be run everytime you  make an update to base

docker pull debian:8
cd base
docker build --no-cache -t=ff0000/base-machine:latest base-machine

cd ../db
docker build --no-cache -t=ff0000/db-machine:latest db-machine

cd ../dev
docker build --no-cache -t=ff0000/dev-machine:0.2 dev-machine

cd ../app
docker build --no-cache -t=ff0000/app-machine:latest app-machine

cd ../lb
docker build --no-cache -t=ff0000/lb-machine:latest lb-machine
