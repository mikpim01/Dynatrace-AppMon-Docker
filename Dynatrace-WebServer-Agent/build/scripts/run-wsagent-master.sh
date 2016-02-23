#!/bin/bash
AGENT_NAME=${AGENT_NAME:-"dtwsagent"}
LOG_LEVEL=${LOG_LEVEL:-"info"}

# Attempt to auto-discover the Dynatrace Collector through the environment when
# the container has been --linked to a 'dynatrace/collector' container instance
# with a link alias 'dtcollector'.
#
# Example: docker run --link dtcollector-1:dtcollector httpd
#
# Auto-discovery can be overridden by providing the $COLLECTOR variable through
# the environment.
COLLECTOR_HOST_NAME=${DTCOLLECTOR_ENV_HOST_NAME:-"docker-dtcollector"}
COLLECTOR_PORT=${DTCOLLECTOR_ENV_AGENT_PORT:-"9998"}
COLLECTOR=${COLLECTOR:-"${COLLECTOR_HOST_NAME}:${COLLECTOR_PORT}"}

# Attempt to auto-discover the Dynatrace Web Server Agent configuration through
# the environment when the container has been --linked to a 'dynatrace/wsagent'
# container instance with a link alias 'dtwsagent'.
#
# Example: docker run --link dtwsagent-1:dtwsagent httpd
#
# Auto-discovery can be overridden by providing the $INI variable through
# the environment.
INI=${DTWSAGENT_ENV_INI:-"/dynatrace/agent/conf/dtwsagent.ini"}

sed -i -r "s/^#?Name.*/Name ${AGENT_NAME}/;s/^#?Server.*/Server ${COLLECTOR}/;s/^#?Loglevel.*/Loglevel ${LOG_LEVEL}/;s/^#?ConsoleLoglevel.*/ConsoleLoglevel ${LOG_LEVEL}/" ${INI}

${DTWSAGENT_ENV_BIN64} &