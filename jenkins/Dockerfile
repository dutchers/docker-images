FROM jenkins

USER root
RUN mkdir /var/log/jenkins
RUN chown -R  jenkins:jenkins /var/log/jenkins
RUN echo "alias ll='ls -l'" >> /etc/profile
USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt
