FROM ff0000/base-machine:latest
MAINTAINER RED Interactive Agency <geeks@ff0000.com>

##
## Load Balancer using NGINX
## We started off with haproxy but for some reason haproxy and our primary
## docker provider Joyent don't play well together.
##
## This image runs nginx and cron in a supervisor process. Giving us the illusion
## of normal machine with normal logs etc. This is important on the LB as we
## don't want destroy and recreate the machine everytime we need to make a change.
##

# base machine sets up the developer user revert to root for
# building
USER root
WORKDIR /

RUN apt-get update && apt-get upgrade -y

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

COPY ./supervisord.conf  /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
