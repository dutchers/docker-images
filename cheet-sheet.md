# Docker Cheet Sheet

## Tools

###Docker 

Docker is client/server application user for managing containers. The client/server nature of it important to understand as that is what allows you to manage container on systems that are not your own machine. It enables you to use boot2docker, Joyents Triton, or any  remote docker host to manage your images. Your docker workflow is composed of 

**Docker Things**

Images
    These are the built server snapshots from which you run containers. Think of them as the Class from which you instantiate Objects. Docker Images can be composed from Dockerfiles, which are recipie for createing images. Images can be stored in a repository like hub.docker.com or built on the fly. Images are a series of file system segments, not a contigious block, this enables images to be diffed and versioned similar a git repository. This segmented nature also reduces build time and bandwidth requirements when moving images around the network.

Containers
    If Images are Classes, Containers are Objects. Containers are running instances of images that can have different internal states; configurations, running processes, data. It is useful to think of them similarly to a running Virtual Machine, this can however get you into trouble. Containers can be stopped, started, and destroyed. Stopping a container maintains it's internal state. Destroying it will remove all of it's state. It is important to note that container state is not saved back to the image. All data in a container is transient. Persistence can be acheived by mounting volumes into a container. It is also important to note that by default containers are NAT'd throught the host IP address. This has implications for how ports are assigned for instance if you had two Django instances running they could not both use port 8000. Understanding how this works will make your life easier, but is beyond the scope of this cheetsheet. 

Dockerfile
    This is the reciepe for building a Docker Image. It's a text file, it's easy to read, and easy to distribute. It's even useful for passing around to show people how to do something.

Repository
    This is just like a centralized git repository. It is where you push, pull, and update your images. The most common one is http://hub.docker.com.  There will probably be more once docker-distribute becomes usefull, probably 2.1.



**Commands**

`docker pull` 
    Pulls an image. If the repository has a newer version of the image, it pulls the diffs between your copy and the repository.

`docker run`
    This creates a container from your image and starts it. The options are unpacked below.

`docker run -it dev-machine /bin/zsh` 
    Runs the dev-machine in interactive mode with the command /bin/zsh. This command will start the container, connect you to it and give you a zsh shell prompt. Note the last arguement `/bin/zsh` could be anything, want to start nginx replace it with `/usr/sbin/nginx` but really the only time you -it is to get a shell.

`docker run -it -p 8000:8000 ff0000/dev-machine:latest /bin/zsh`
    Does the same as above but maps port 8000 of the container to port 8000 of the container to port 8000 on the host machine. This let's you access http://yourip:8000

`docker run -it -p 8000:8000 -v .:/srv/active dev-machine /bin/zsh`
    Does the same as above but also mounts the directory you are in to the directoyr /srv/active in the container. 

`docker run -d dev-machine` 
    This will run the container in the background.

`docker exec -it container_name /bin/zsh`
    This drops you into zsh on running container. In container world we don't often use ssh. This is the preferred method, don't use `docker connect`

`docker ps`
    Lists running containers. The output looks like this, and yes it runsing into the 180th column!

'''
CONTAINER ID        IMAGE                       COMMAND                CREATED             STATUS              PORTS                                        NAMES
c0fc29915e4c        ff0000/dev-machine:latest   "/bin/bash"            3 seconds ago       Up 2 seconds        0.0.0.0:80->80/tcp, 0.0.0.0:8000->8000/tcp   dockerimages_projectdev_1     
aa21dfa891a6        redis:2.8                   "/entrypoint.sh redi   4 seconds ago       Up 3 seconds        6379/tcp                                     dockerimages_projectredis_1   
8071090ad77e        mdillon/postgis:latest      "/docker-entrypoint.   4 seconds ago       Up 3 seconds        0.0.0.0:5432->5432/tcp                       dockerimages_projectdb_1  
'''

`docker ps -a`
    Lists all containers. This important, if you have stopped containers they are still using your disk space, reserving ports, and won't let you remove or update their images. Also if you stopped a container and you want to restart it, this is how you get it's name.

`docker stop <container_name>`
    This stops but does not remove the container.

`docker rm <container_name>`
    This will remove the container unless it is running.

`docker rm $(docker ps -a |  awk '{print $1}')`
    This will remove all non-running containers. You'd think there would be a `docker rm -a`, but there isn't.

`docker images`
    List all images.  The output can be missleading. This is because images are more complex than we are going into here. What you care about is the REPOSITORY and TAG columns.

`docker rmi <repository>:<tag>`
    Remove image. For example `docker rmi ff0000/dev-machine:latest`.  

`docker rmi $(docker ps -a | awk 'print $1')`
    Remove all the images. 



### Docker Compose

    Thank you, thank you, thank you. If you want to, you can type out a very long list of arguements to your `docker run` command that let's you mount volumes, link containers, and specify environment variables, and various other things. You can but you will rage quit docker pretty quickly if you do. docker-compose lets you specify them in yml file, and then automates much of the nameing and coordination for you.  Docker compose was previously called fig, they are the same thing.
