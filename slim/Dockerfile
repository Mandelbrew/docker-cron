FROM       python:slim
MAINTAINER Carlos Avila "cavila@mandelbrew.com"

# Prep env
ENV        DEBIAN_FRONTEND        noninteractive
ENV        PYTHONUNBUFFERED       1
ENV        PRE_RESOURCES_HOOK     ''
ENV        RESOURCES_URL          ''
ENV        POST_RESOURCES_HOOK    ''

# Operating System
RUN        apt-get update -y \
           && apt-get install -y \
             postgresql \
             awscli \
             curl \
           && apt-get autoremove -y \
           && apt-get clean -y \
           && rm -rf /var/lib/apt/lists/* \
           && rm -rf /usr/share/man/*

# Application
WORKDIR	   /opt/docker

ADD        scripts/docker-cmd.sh docker-cmd.sh
RUN        chmod +x docker-cmd.sh

CMD        ["./docker-cmd.sh"]