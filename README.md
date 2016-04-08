# RED Docker machines

This repo is intended to provide the base images and example compose files for project development. You can use the images directly but they are also easily extend. Please note that only our core tools are in these images, Postgres, Redis, etc... all use generic images from Docker Hub.

Our docker images are versioned. Versions are reflected in the tags. Tags match releases in github. If a given project calls for version 0.1 of our docker image it can be pulled and run by using the tag name. However the dev.yml file and docker compose should do this for you.

## Image Summaries

<dl>
  <dt>base-machine</dt>
  <dd>Contains basic tools and libs common to all environments.</dd>

  <dt>dev-machine</dt>
  <dd>Use for development. Contains build tools, server environment, and mounts your local directory.</dd>

  <dt>db-machine</dt>
  <dd>PostreSQL 9.4. Supports Master/Slave and Standalone configurations.</dd>

  <dt>app-machine</dt>
  <dd>Application server for production use. Runs gunicorn, and nginx.</dd>

  <dt>lb-machine</dt>
  <dd>Load Balancer. Runs nginx. Yes haproxy would have been better... see machine docs.</dd>
</dl>


## Personalizing Your Dev Environment

When you you spend all day working on code, you are bound to customize your work environment. We encourage this. The best way to pull this off is to create a local Dockerfile and/or compose file that extends our base image as such.

```
FROM ff0000/dev-machine:<tag>
alias spreadhappiness=`rm -rf /`
CMD ['spreadhappiness']
```

It is important not to push personal preferences into the base image. We all have to use those images as such they contain only widely adopted idioms.

## How To run this

You can run this all kinds of ways but probably the easiest is to use docker-compose. Here are the instructions for installing

https://docs.docker.com/compose/install/

At the moment there are three docker compose yaml configs in the root directory. Use them like this

`docker-compose -f dev.yml up -d`
    Pull the dev image from Docker Hub and start appropriate containers. This will not start any web services. This will also pull and link the redis and postgres images.

`docker-compose -f build.yml up -d`
    Build the dev image locally ( this takes about 5 mins ). It will also pull the redis and postgres images from Docker Hub.

`docker-compose -f qa.yml up -d`
    Pull the dev image from Docker Hub and start appropriate containers. This will start all web services. This will also pull and link the redis and postgres images.

## Images

### dev-machine

dev-machine is intended to provide a standardized development environment. It does not start any services by default. This image provides a development environment with the version of the tools and library used to create project. The idea is that future-you can just get to work and not spend days reconstructing what, then, will be outdated libraries and services.

Start with `docker-compose -f dev.yml up -d`. That will spin up the container and it's supporting containers. The command will also establish the links between the containers. To work within the container type `docker exec -it dockerimages_projectdev_1 /bin/zsh`.  Yes zsh and oh-my-zsh are installed ( do a little happy dance ). For the old-school just `/zsh/bash/g` in the previous command and you'll be happy too.

If you cd into /srv/active and `ls` you'll notice you are in the docker-images directory. That's because we mounted the docker-images directory inside of the container.  This is for demonstration purposes. Since our toolset is installed you can now bootstrap a project using yeoman.

```
mkdir tmp
yo red-django
```

Please delete the tmp directory and don't commit it back once you are done.
