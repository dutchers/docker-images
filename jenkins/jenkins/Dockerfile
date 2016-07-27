FROM jenkinsci/jenkins:2.11

USER root

RUN apt-get update && apt-get upgrade -y

ENV NODE_VERSION  6.2.2

RUN echo $NODE_VERSION

RUN apt-get -y install python3 python3-pip python3-psycopg2 sloccount
RUN pip3 install virtualenv

# Installing `node` and `npm`
# For running joyents triton cli app
RUN curl -O http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz && \
    tar -zxf node-v$NODE_VERSION-linux-x64.tar.gz && \
    rm node-v$NODE_VERSION-linux-x64.tar.gz  && \
    cp -r node-v$NODE_VERSION-linux-x64 /opt/local/
ENV PATH /opt/local/node-v$NODE_VERSION-linux-x64/bin:$PATH
RUN ls -al /opt/local/bin
RUN ln -s /opt/local/bin/npm /usr/bin/npm
RUN ln -s /opt/local/bin/node /usr/bin/node


RUN echo "prefix = /srv/.npm-packages" >> /etc/npmrc
RUN npm install -g triton webpack grunt-cli pngjs node-sass
RUN ln -s /opt/local/bin/webpack /usr/bin/webpack

# We need docker potetially for spinning up and and down test instances.
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install apt-transport-https
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN cat /etc/apt/sources.list.d/docker.list
RUN apt-get -y update
RUN apt-get -y install docker-engine
RUN curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose


# NGINX to front jenkins server
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


# Clients for our external services
RUN apt-get install -y redis-tools postgresql-client-common postgresql-client


RUN apt-get install -y supervisor vim wget fontforge libcairo2 libjpeg-dev zlib1g-dev binutils libproj-dev gdal-bin
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf


RUN mkdir -p /var/log/jenkins
RUN mkdir -p /var/cache/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins
ENV JAVA_OPTS="-Xmx8192m"


# overide jenkins entrypoint because it causes failures in the cloud.
ENTRYPOINT []
#CMD ["/usr/local/bin/jenkins.sh"]
CMD ["/usr/bin/supervisord"]
