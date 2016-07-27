FROM alpine:latest

# Create the jenkins user
#RUN useradd -d "/var/jenkins_home" -u 1000 -m -s /bin/bash jenkins
RUN adduser -h "/var/jenkins_home" -u 1000 -s /bin/bash -D jenkins

# Create the folders and volume mount points
RUN mkdir -p /var/log/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
VOLUME ["/var/log/jenkins", "/var/jenkins_home"]

#USER jenkins
CMD ["echo", "Data container for Jenkins"]
