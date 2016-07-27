#!/usr/bin/env bash
#docker build -t=jenkins-data data
#docker build -t=ff0000/jenkins-server:latest jenkins
#docker push ff0000/jenkins-server:latest

eval "$(triton env --docker ff0000)"

docker login

#docker pull ff0000/jenkins-server:latest
#docker build -t=jenkins-data data
docker run --name jenkins-data jenkins-data
#docker stop jenkins-master
#docker rm jenkins-master
docker run -p 80:80 -p 8080:8080 -p 50000:50000 -m=8G --name=jenkins-master --volumes-from=jenkins-data -d  ff0000/jenkins-server:latest
docker run -p 80:80 -m=8G --name=jenkins-master --volumes-from=jenkins-data -d  ff0000/jenkins-server:latest
docker inspect -f '{{ .NetworkSettings.IPAddress }}' jenkins-master
sleep 60
docker exec -it jenkins-master cat /var/jenkins_home/secrets/initialAdminPassword
