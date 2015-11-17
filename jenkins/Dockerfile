FROM jenkins

ENV NODE_VERSION 0.10.36

USER root
RUN chown -R jenkins /var/jenkins_home
RUN mkdir /var/log/jenkins
RUN chown -R  jenkins:jenkins /var/log/jenkins
RUN echo "alias ll='ls -l'" >> /etc/profile

USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

USER root

RUN apt-get update

RUN apt-get install sudo
RUN adduser jenkins sudo
RUN echo 'jenkins ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Installing Python and required packages for deploying
RUN apt-get install -y python python-dev python-pip python-pillow python-openssl
RUN pip install virtualenv==13.1.2
RUN pip install Fabric==1.10.2
RUN pip install Paramiko==1.15.2
RUN pip install red-fab-deploy
RUN pip install red-fab-deploy2==0.2.4

# Installing `node` and `npm`
RUN mkdir /opt/local
RUN mkdir -p /srv/.npm-packages
RUN apt-get install bzip2 -y
RUN curl -O http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz
RUN tar -zxf node-v$NODE_VERSION-linux-x64.tar.gz
RUN rm node-v$NODE_VERSION-linux-x64.tar.gz
RUN mv node-v$NODE_VERSION-linux-x64 /opt/local/
RUN ln -s /opt/local/node-v$NODE_VERSION-linux-x64/bin/node /usr/local/bin/
RUN echo "prefix = /srv/.npm-packages" >> /etc/npmrc
RUN /opt/local/node-v$NODE_VERSION-linux-x64/bin/npm install -g npm@2.8.3
RUN ln -s /opt/local/node-v0.10.36-linux-x64/bin/npm /usr/local/bin/npm
RUN npm install -g yo@1.4.6 bower@1.4.1 grunt-cli@0.1.13
RUN npm install -g generator-red-django@0.6.0
RUN npm install -g generator-red-static@0.6.0
RUN npm install -g pngjs@0.4.0
RUN npm install -g phantomjs@1.9.17

USER jenkins
