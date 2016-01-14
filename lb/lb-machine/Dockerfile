FROM ff0000/base-machine:latest
MAINTAINER RED Interactive Agency <geeks@ff0000.com>

# base machine sets up the developer user revert to root for
# building
USER root
WORKDIR /

RUN apt-get update && apt-get upgrade -y

# haproxy doesn't log to files... cause it's special.
RUN apt-get -y install rsyslog

RUN apt-get install -y haproxy
RUN mkdir /run/haproxy
RUN mkdir /var/log/haproxy/

COPY ./haproxy.cfg /etc/haproxy/haproxy.cfg
COPY ./supervisord.conf  /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
