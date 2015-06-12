# RED Docker machines

This repo is intended to provide the base images and example compose files for project development. You can use the images directly but they are also easily extend. Please note that only our core tools are in these images, Postgres, Redis, Solr, etc... all use generic images from Docker Hub.

## dev-machine

dev-machine is intended to provide a standardized development environment. It does not start any services, it simply provides a standardized development environment for a project with libraries tools all versioned to the context of the project. So you future you can just get to work and not spend days reconstructing what, then, will be outdated garbage on your computer. 

Start services with `docker-compose -f dev.yml up -d`. That will spin up the container, it's supporting containers, and establish the links between them. To work within the container type `docker exec -it docker_projectdev_1 /bin/zsh`.  Yes zsh and oh-my-zsh are installed ( do a little happy dance ). For the old-school just `/zsh/bash/g` in the previous command and you'll be happy too.

If you cd into /srv/active you'll notice you are in the docker-containers directory and `ls` things will look pretty familiar. That's because we mounted the docker-containers directory inside of the container. You'll want to customize the dev.yml file for your project. We'll do that for you when we update generator-red-django.