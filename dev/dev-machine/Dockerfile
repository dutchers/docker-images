#
# Base developer image for RED Interactive Agency
# This image includes the core frameworks, libraries, and tools
# needed to work on dockerized projects at RED.
#
# Core Toolset
#
# Django 1.7.x
# Node 4 LTS
# Redis Client
# Postgres Client
# zsh
# git
# Python 2.7
# yeoman
# bower
#
# External Services such as Postgres and Redis should linked.

FROM ff0000/base-machine:latest

FROM ff0000/base-machine:latest
MAINTAINER RED Interactive Agency <geeks@ff0000.com>

# base machine sets up the developer user revert to root for
# building
USER root
WORKDIR /


# Set the Node Version you want. I believe FE is currently pegged to .12.x
ENV NODE_VERSION  4.4.5

# Nothing works if you don't do this first
RUN apt-get update && apt-get upgrade -y

# If you are installing binaries or compiling code output should
# go here so as not to conflict with  /usr/local
RUN mkdir /srv/configs

# Install base tools
RUN apt-get install -y supervisor fontforge libcairo2 libjpeg-dev zlib1g-dev

# For PostGIS and GeoDjango
RUN apt-get install -y binutils libproj-dev gdal-bin

# Clients for our external services
RUN apt-get install -y redis-tools postgresql-client-common postgresql-client

# Let's put Nginx on here so we can mess with configs.
# Need Http2 so default package isn't good enough
RUN wget http://nginx.org/keys/nginx_signing.key && \
    apt-key add nginx_signing.key && \
    echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list && \
    echo "deb-src http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y nginx
# nginx runs in foreground
RUN sed -i "1idaemon off;" /etc/nginx/nginx.conf
COPY ./nginx /etc/nginx
RUN mkdir /var/log/gunicorn && chown nginx /var/log/gunicorn

# Set up supervisor and gunicorn
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./gunicorn /srv/configs/gunicorn

# Python things we don't want to waste time compiling
# virtualenv, is deprecated. Our current tools need it though so it's here.
RUN apt-get install -y python python-dev python-pip python-pillow \
    python-psycopg2 python-virtualenv

COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Installing `node` and `npm`
RUN curl -O http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz && \
    tar -zxf node-v$NODE_VERSION-linux-x64.tar.gz && \
    rm node-v$NODE_VERSION-linux-x64.tar.gz  && \
    cp -r node-v$NODE_VERSION-linux-x64 /opt/local/
ENV PATH /opt/local/node-v$NODE_VERSION-linux-x64/bin:$PATH

# Add Node stuff to PATH
RUN echo "export PATH=$PATH:/opt/local/node-v$NODE_VERSION-linux-x64/bin" >> /home/developer/.zshrc

# set npm global node_modules
RUN echo "prefix = /srv/.npm-packages" >> /etc/npmrc
RUN npm install -g bower grunt-cli pngjs webpack webpack-dev-server


# Docker
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install apt-transport-https
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN cat /etc/apt/sources.list.d/docker.list
RUN apt-get -y update
RUN apt-get -y install docker-engine

# docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.6.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose


COPY ./bin/ /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

RUN echo "export PATH=$PATH:/opt/local/node-v$NODE_VERSION-linux-x64/bin \n \
    alias djr='python /srv/active/project/manage.py runserver 0.0.0.0:8000' \n \
    alias djm='python /srv/active/project/manage.py migrate' \n \
    alias djmm='python /srv/active/project/manage.py makemigrations' \n \
    alias djcs='python /srv/active/project/manage.py createsuperuser' \n \
    alias djs='python /srv/active/project/manage.py shell_plus' \n \
    alias djsh='python /srv/active/project/manage.py shell' \n \
    alias djdb='python /srv/active/project/manage.py dbshell'" >> /home/developer/.zshrc

RUN chown -R developer:developer /home/developer

USER developer
WORKDIR /home/developer

VOLUME /srv/active

EXPOSE 8000 80 3000 3001

CMD ["/bin/bash"]
