FROM ubuntu:20.04

# Set the working directory inside container
WORKDIR /src

# Install any needed packages

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update; \
    apt-get install -y --allow-unauthenticated aptitude; \
    aptitude install -y --allow-untrusted \
    wget \
    git \
    gnupg \
    nano \
    screen \
    inetutils-ping \
    sudo \
    locales \
    xvfb \
    x11vnc


# Setup rfuser

ARG user=rfuser
ARG user_pass=rfuser
ARG group=rfuser
ARG uid=1000
ARG gid=1000

RUN groupadd -g ${gid} ${group} && \
    useradd -u ${uid} -g ${group} -s /bin/bash ${user} && \
    usermod -aG sudo ${user} && \
    mkdir -p /home/${user} && \
    chown -R ${user}:${group} /home/${user} && \
    echo "${user}:${user_pass}" | chpasswd

RUN echo "DISPLAY=:0" >> /etc/environment && \
    echo "LANG=en_US.UTF-8" >> /etc/environment \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && update-locale

# Install ratflow-core

COPY . /src/ratflow-desktop
RUN cd /src/ratflow-desktop && ls -lah && ./install.sh ./installers/focal

# Run entrypoint

EXPOSE 5900/tcp

# Run commands when the container launches
ADD docker/focal/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
