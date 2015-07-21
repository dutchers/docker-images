Docker Cheet Sheet
------------------

Docker
======

Docker is client/server application user for managing containers. The client/server nature of it important to understand as that is what allows you to manage container on systems that are not your own machine. It enables you to use boot2docker, Joyents Triton, or any  remote docker host to manage your images. Your docker workflow is composed of

**Docker Things**

Dockerfile
    This is the reciepe for building a Docker Image. It's a text file, it's easy to read, and easy to distribute. It's even useful for passing around to show people who don't use docker how to do something.

Images
    These are the built server snapshots from which you run containers. Think of them as the Class from which you instantiate Objects. Docker Images are built from Dockerfiles. Images can be stored in a repository like hub.docker.com or built on the fly. Images are a series of file system segments, not a contigious block, this enables images to be diffed and versioned similar a git repository. This segmented nature also reduces build time and bandwidth requirements when moving images around the network.

Containers
    If Images are Classes, Containers are Objects. Containers are running instances of images that can have different internal states; configurations, running processes, and data. It is useful to think of them similarly to a running Virtual Machine, this can however get you into trouble. Containers can be stopped, started, and destroyed. Stopping a container maintains it's internal state. Destroying it will remove all of it's state. It is important to note that container state is not saved back to the image. All data in a container is transient. Persistence can be acheived by mounting volumes into a container. It is also important to note that by default containers are NAT'd throught the host IP address. This has implications for how ports are assigned for instance if you had two Django instances running they could not both use port 8000. Understanding how this works will make your life easier, but is beyond the scope of this cheetsheet.

Repository
    This is just like a centralized git repository. It is where you push, pull, and update your images. The most common one is http://hub.docker.com.  There will probably be more once docker-distribute becomes usefull, that should happen around 2.1.



**Commands**

The commands here use our image names so it's easy to use this repo to run them.

``docker pull ff0000/dev-machine:latest``
    Pulls an image. If the repository has a newer version of the image, it pulls the diffs between your copy and the repository.

``docker run ff0000/dev-machine:latest``
    This creates a container from your image and starts it. The options are unpacked below.

``docker run -it ff0000/dev-machine:latest /bin/zsh``
    Runs the dev-machine in interactive mode with the command /bin/zsh. This command will start the container, connect you to it and give you a zsh shell prompt. Note the last arguement `/bin/zsh` could be anything, want to start nginx replace it with `/usr/sbin/nginx` but in reality, the only time you -it is to get a shell.

``docker run -it -p 8000:8000 ff0000/dev-machine:latest /bin/zsh``
    Does the same as above but maps port 8000 of the container to port 8000 of the container to port 8000 on the host machine. This let's you access http://yourip:8000

``docker run -it -p 8000:8000 -v .:/srv/active ff0000/dev-machine:latest /bin/zsh``
    Does the same as above but also mounts the directory you are in to the directory /srv/active in the container.

``docker run -d ff0000/dev-machine:latest``
    This will run the container in the background.

``docker ps``
    Lists running containers. There is example output below. Yes it runs into the 180th column, hope you have a big monitor!

::

    CONTAINER ID        IMAGE                       COMMAND                CREATED             STATUS              PORTS                                        NAMES
    c0fc29915e4c        ff0000/dev-machine:latest   "/bin/bash"            3 seconds ago       Up 2 seconds        0.0.0.0:80->80/tcp, 0.0.0.0:8000->8000/tcp   dockerimages_projectdev_1
    aa21dfa891a6        redis:2.8                   "/entrypoint.sh redi   4 seconds ago       Up 3 seconds        6379/tcp                                     dockerimages_projectredis_1
    8071090ad77e        mdillon/postgis:latest      "/docker-entrypoint.   4 seconds ago       Up 3 seconds        0.0.0.0:5432->5432/tcp                       dockerimages_projectdb_1

``docker ps -a``
    Lists all containers. This important, if you have stopped containers they are still using your disk space, reserving ports, and won't let you remove or update their images. Also if you stopped a container and you want to restart it, this is how you get it's name.

``docker exec -it dockerimages_projectdev_1 /bin/zsh``
    This drops you into zsh on running container. In 'containerland' we don't often use ssh. This is the preferred method, don't use `docker connect`.

``docker stop dockerimages_projectdev_1``
    This stops but does not remove the container.

``docker stop $(docker ps |  awk '{print $1}')``
    This stops but does not remove all the containers. It will output an error because CONTAINER ID is not a container id but it's as good as you're going to get until a ``-a`` option is addded.

``docker rm docker images_projectdev_1``
    This will remove the container unless it is running.

``docker rm $(docker ps -a |  awk '{print $1}')``
    This will remove all non-running containers. You'd think there would be a `docker rm -a`, but there isn't.

``docker images``
    List all images.  The output can be missleading. This is because images are more complex than we are going to get into here. What you care about is the REPOSITORY and TAG columns.

::

    REPOSITORY           TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    ff0000/dev-machine   latest              178a06678e32        22 hours ago        927.6 MB
    mdillon/postgis      latest              338d438691c2        4 days ago          375.7 MB
    redis                2.8                 dbbd133bdac6        3 weeks ago         110.8 MB
    debian               7                   b96d1548a24e        4 weeks ago         84.97 MB

``docker rmi debian:7``
    Remove image.

``docker rmi $(docker ps -a | awk 'print $1')``
    Remove all the images. Again, why no ``docker rmi -a``!??!


Docker Compose
==============

Thank you, thank you, thank you.

If you would like please feel free to type out the long list of arguements to your `docker run` command that let you mount volumes, link containers, specify environment variables, and various other things. You can, but you will rage quit docker pretty quickly if you do. docker-compose lets you specify all your arguments in yml file, and then automates much of the naming and coordination for you.  Docker compose was previously called fig, so if you see people refer to fig, they are the same thing.

There is an important got-ya in docker-compose. If you specify `build` you can't specify `image`. There is no, "if an image exists pull it, otherwise build it" This is easy to work around, we just have a compose file for building images and one for running a built image. We only use the former when changing our core images and the later for developing websites.

**Commands**

``docker-compose build``
    This command looks for a docker-compose.yml file. It will use that to pull and build any images defined in that file .

``docker-compose -f build.yml build``
    This does the same as above but using a customized compose file.

``docker-compose up -d``
    This will bring up the server set defined in docker-compose.yml. If the images need to be pulled or built it will do that before bringing up and linking the containers.

``docker-compose -f dev.yml up -d``
    This does the same as above but using a customized compose file.
