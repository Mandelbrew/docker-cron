FROM       python:alpine
MAINTAINER Carlos Avila "cavila@mandelbrew.com"

# Prep env
ENV        PYTHONUNBUFFERED       1
ENV        PRE_RESOURCES_HOOK     ''
ENV        RESOURCES_URL          ''
ENV        POST_RESOURCES_HOOK    ''

# Operating System
RUN        apk update \
           && apk add postgresql curl \
           && pip3 install --no-cache-dir --upgrade pip setuptools wheel \
           && pip3 install --no-cache-dir awscli

# Application
WORKDIR	   /opt/docker

ADD        scripts/docker-cmd.sh docker-cmd.sh
RUN        chmod +x docker-cmd.sh

CMD        ["./docker-cmd.sh"]