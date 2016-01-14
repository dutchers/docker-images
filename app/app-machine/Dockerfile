#
# Base App Server image for RED Interactive Agency
# This image includes the core frameworks, libraries, and tools.
#
# Core Toolset
#
# Django 1.8.x
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
MAINTAINER RED Interactive Agency <geeks@ff0000.com>

# base machine sets up the developer user revert to root for
# building
USER root
WORKDIR /

ENV NODE_VERSION  4.2.4

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
#RUN sed -i "1idaemon off;" /etc/nginx/nginx.conf
RUN mkdir /srv/www
RUN echo "No App Running" >> /srv/www/index.html
COPY ./nginx /etc/nginx
RUN mkdir /var/log/gunicorn && chown nginx /var/log/gunicorn

# Set up supervisor and gunicorn
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./gunicorn /srv/configs/gunicorn

# Python things we don't want to waste time compiling
# virtualenv, is deprecated. Our current tools need it though so it's here.
RUN apt-get install -y python3 python3-dev python3-pip python3-pillow \
    python3-psycopg2

COPY ./requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# Installing `node` and `npm`
RUN curl -O http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz && \
    tar -zxf node-v$NODE_VERSION-linux-x64.tar.gz && \
    rm node-v$NODE_VERSION-linux-x64.tar.gz  && \
    cp -r node-v$NODE_VERSION-linux-x64 /opt/local/ && \
    ln -s /opt/local/node-v$NODE_VERSION-linux-x64/bin/node /usr/local/bin/ && \
    ln -s /opt/local/node-v$NODE_VERSION-linux-x64/bin/npm /usr/local/bin/

RUN npm install -g npm

# set npm global node_modules
RUN echo "prefix = /srv/.npm-packages" >> /etc/npmrc

RUN /usr/local/bin/npm install -g yo bower grunt-cli pngjs

EXPOSE 80

CMD ["/usr/bin/supervisord"]
