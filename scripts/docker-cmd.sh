#!/usr/bin/env sh

set -e

# Prep env
IFS=$(echo -en "\n\b")
CRONTAB=/etc/crontabs/root
TASK_PREFIX='CRON_TASK_'

if [ -z $(printenv | grep ${TASK_PREFIX}) ]; then
    echo "You need to set at least one environment variable with prefix '${TASK_PREFIX}'."
    exit 1
fi

# Pre resources hook
if [ ! -z ${PRE_RESOURCES_HOOK} ]; then
    eval ${PRE_RESOURCES_HOOK};
fi

# Download helper sources
if [ ! -z ${RESOURCES_URL} ]; then
    echo "Downloading resources from ${RESOURCES_URL}"
    curl -L --insecure ${RESOURCES_URL} > resources.tar.gz
    tar -zxvf resources.tar.gz
fi

# Post resources hook
if [ ! -z ${POST_RESOURCES_HOOK} ]; then
    eval ${POST_RESOURCES_HOOK};
fi

# Make env var available for cron jobs
printenv | grep -v "no_proxy" >>/etc/environment

# Parse custom tasks
echo "# Custom tasks" >>${CRONTAB}
for task in $(printenv | grep 'CRON_TASK_'| cut -d= -f2); do
    echo ${task} >>${CRONTAB}
done
echo "# An empty line is required at the end of this file for a valid cron file." >>${CRONTAB}

# Start service
crond -f -l 0
