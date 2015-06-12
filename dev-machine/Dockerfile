#
# Base developer image for RED Interactive Agency
# This image includes the core frameworks, libraries, and tools 
# needed to work on dockerized projects at RED. 
#
# Core Toolset
#
# Django 1.7.x
# Node 0.10.x
# Redis Client 
# Postgres Client 
# zsh
# git 
# Python 2.7
# yeoman
# bower
#
# External Services such as Postgres and Redis should linked.

FROM debian:8

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_VERSION  0.10.36

# Nothing works if you don't do this first
RUN apt-get update && apt-get upgrade -y

# Set locale to US EN UTF8
RUN apt-get install locales -y
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN dpkg-reconfigure locales

# If you are installing binaries or compiling code output should
# go here so as not to conflict with  /usr/local
RUN mkdir /opt/local

# Install base tools
RUN apt-get install -y wget curl htop ntp vim build-essential \
    git-core tmux supervisor zsh sudo

# For PostGIS and GeoDjango
RUN apt-get install -y binutils libproj-dev gdal-bin

# Clients for our external services
RUN apt-get install -y redis-tools postgresql-client-common postgresql-client 

# Python things we don't want to waste time compiling
# No virtualenv, The docker container is the virtualenv
RUN apt-get install -y python python-dev python-pip python-pillow \
    python-psycopg2 

COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt 

# Installing `node` and `npm`
RUN curl -O http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz
RUN tar -zxf node-v$NODE_VERSION-linux-x64.tar.gz
RUN rm node-v$NODE_VERSION-linux-x64.tar.gz
RUN mv node-v$NODE_VERSION-linux-x64 /opt/local/
RUN ln -s /opt/local/node-v$NODE_VERSION-linux-x64/bin/node /usr/local/bin/
RUN wget http://npmjs.org/install.sh && chmod +x install.sh && ./install.sh
RUN rm install.sh

RUN npm install grunt -g
RUN npm install grunt-cli -g
RUN npm install bower -g
RUN npm install yo@1.4.6 -g

# Install oh-my-zsh
# Most every dev here is using this so may as well include it.
# Do not mess with themes.
RUN wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh
RUN sed -i -e '30,52d' ./install.sh
RUN sh ./install.sh

COPY ./zshrc /.zshrc

# So you don't like zsh here's some bash for ya
RUN sed -i -e 's/# export LS_OPTIONS=/export LS_OPTIONS=/g' ~/.bashrc
RUN sed -i -e 's/# alias ll/alias ll/g' ~/.bashrc
RUN sed -i -e 's/# alias ls/alias ls/g' ~/.bashrc

VOLUME /srv/active

EXPOSE 8000 80