# Jenkins Custom image

Files in this folder help you to build a custom `Jenkins` image for installing
specific plugins in your `Jenkins` server. Then you can run a *Docker* container
using that image.

## How to build Jenkins custom image

```
$ docker-compose -f dev.yml build
```

The default container name running *Jenkins* is called *jenkins-server*.

## How to run Jenkins using a Docker container

```
$ docker-compose -f dev.yml up -d
```

## Persistent data

In order to persist data, our *Docker* container is going to use a shared folder
from *host* machine. By default, this folder is `jenkins_data`. However, you can
change `volumes` directive on `dev.yml` for using a different location.

## How to connect to Jenkins

Open your browser and go to the following URL:

```
http://<docker_ip>:8080
```

## Log file

*Dockerfile* will create a new path for using a specific *log* file for *Jenkins*. If you
want to see *log* information there, you can run the following command:

```
$ docker exec jenkins-server tail -f /var/log/jenkins/jenkins.log
```

### How to get log file is Jenkins crashes

```
$ docker-compose -f dev.yml stop
$ docker cp jenkins-server:/var/log/jenkins/jenkins.log jenkins.log
```

After executing the commands above, you'll get `jenkins.log` file in your current host
machine folder.

## How to stop Jenkins

```
$ docker-compose -f dev.yml stop
```

