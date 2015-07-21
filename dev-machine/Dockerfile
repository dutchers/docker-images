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
RUN apt-get install locales -y && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen && \
    locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN dpkg-reconfigure locales

# If you are installing binaries or compiling code output should
# go here so as not to conflict with  /usr/local
RUN mkdir /opt/local
RUN mkdir /srv/configs

# Install base tools
RUN apt-get install -y wget curl htop ntp vim build-essential \
    git-core tmux supervisor zsh sudo libzmq3-dev gettext fontforge \
    libcairo2 libjpeg-dev zlib1g-dev

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
# virtualenv, is depricated. Our current tools need it though so it's here.
RUN apt-get install -y python python-dev python-pip python-pillow \
    python-psycopg2 python-virtualenv


COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Installing `node` and `npm`
RUN curl -O http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz && \
    tar -zxf node-v$NODE_VERSION-linux-x64.tar.gz && \
    rm node-v$NODE_VERSION-linux-x64.tar.gz && \
    mv node-v$NODE_VERSION-linux-x64 /opt/local/ && \
    ln -s /opt/local/node-v$NODE_VERSION-linux-x64/bin/node /usr/local/bin/

# set npm global node_modules
RUN echo "prefix = /srv/.npm-packages" >> /etc/npmrc
RUN wget http://npmjs.org/install.sh && chmod +x install.sh && \
    ./install.sh && rm install.sh

RUN npm install -g npm@2.8.3 && \
    npm install -g yo@1.4.6 bower@1.4.1 grunt-cli@0.1.13 && \
    npm install -g generator-red-django@0.6.0 && \
    npm install -g generator-red-static@0.6.0 && \
    npm install -g pngjs@0.4.0 && \
    npm install -g phantomjs@1.9.17

# Do a bunch of stuff because yeoman has opinions instead of education
# Sorry folks you are condemened to typing sudo in front of everything
RUN adduser --disabled-password --gecos "" developer && \
      echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV HOME /home/developer
RUN chown developer:developer /srv
USER developer
WORKDIR /home/developer

# Install oh-my-zsh
# Most every dev here is using this so may as well include it.
# Do not mess with themes.
RUN wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh
RUN sed -i -e '30,52d' ./install.sh
RUN sh ./install.sh

COPY ./zshrc /home/developer/.zshrc
COPY red-docker.zsh-theme .oh-my-zsh/themes/

# So you don't like zsh here's some bash for ya
RUN sed -i -e 's/# export LS_OPTIONS=/export LS_OPTIONS=/g' /home/developer/.bashrc && \
    sed -i -e 's/# alias ll/alias ll/g' /home/developer/.bashrc && \
    sed -i -e 's/# alias ls/alias ls/g' /home/developer/.bashrc

VOLUME /srv/active

EXPOSE 8000 80

CMD ["/bin/bash"]
