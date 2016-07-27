#!/usr/bin/env bash
eval "$(triton env --docker adtech)"
docker stop jenkins-master
#docker stop jenkins-data
docker rm jenkins-master
#docker rm jenkins-data
