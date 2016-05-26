#!/bin/bash

# Update all the docker images.
# This script pulls the latest debian.  Builds base-machine and then builds all the images that
# extend base-machine. It should be run everytime you  make an update to base

docker push ff0000/base-machine:latest

docker push ff0000/db-machine:latest

docker push ff0000/dev-machine:0.2.1

docker push ff0000/app-machine:latest

docker push ff0000/lb-machine:latest
