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

# Download helper sources
if [ ! -z ${RESOURCES_URL} ]; then
    echo "Downloading resources from ${RESOURCES_URL}"
    wget ${RESOURCES_URL}
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
