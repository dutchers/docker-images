#
# Base base-machine for building images for RED Interactive Agency
# All images should inherit from this image. Any change you make
# to this image will impact every child image. Be mindful.
#

FROM debian:8

ENV DEBIAN_FRONTEND noninteractive
MAINTAINER RED Interactive Agency <geeks@ff0000.com>

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

# Install base tools
RUN apt-get install -y wget curl htop vim build-essential \
    git-core tmux supervisor zsh sudo libzmq3-dev gettext man psmisc \
    rsyslog cron

# Do a bunch of stuff because yeoman has opinions instead of education
# Sorry folks you are condemened to typing sudo in front of everything
RUN adduser --disabled-password --gecos "" developer && \
      echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV HOME /home/developer
RUN chown developer:developer /srv
USER developer
WORKDIR /home/developer
RUN mkdir /home/developer/.ssh

# Install oh-my-zsh
# Most every dev here is using this so may as well include it.
# Do not mess with themes.
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

COPY ./zshrc /home/developer/.zshrc
COPY red-docker.zsh-theme .oh-my-zsh/themes/
COPY ./bashrc /home/developer/.bashrc
COPY ./vimrc /home/developer/.vimrc

CMD ["/bin/zsh"]
