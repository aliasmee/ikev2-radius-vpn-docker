#!/bin/bash
# Source File From: https://raw.githubusercontent.com/tpdock/freeradius/master/docker-entrypoint.sh

set -eo pipefail

####################################################################
###  Server Configuration                                        ###
####################################################################
if [ -z "$RADIUS_LISTEN_IP" ]; then
  export RADIUS_LISTEN_IP=${PRIVATE_IP:-127.0.0.1}
fi

envsubst '
          ${RADIUS_LISTEN_IP}
         ' < default.template > /etc/raddb/sites-available/default

####################################################################


####################################################################
###  Clients Configuration                                       ###
####################################################################
if [ -z "$RADIUS_CLIENTS" ]; then
  export RADIUS_CLIENTS=""
else
  while IFS=',' read -ra ADDR; do
      for i in "${ADDR[@]}"; do
          IFS='@' read SECRET IP <<<$i
          OUT+=$'client '$IP$' {\n  secret      = '${SECRET}$'\n  require_message_authenticator = no\n}\n\n'
      done
  done  <<< "$RADIUS_CLIENTS"
  export RADIUS_CLIENTS="$OUT"
fi
envsubst '${RADIUS_CLIENTS}
         ' < clients.conf.template > /etc/raddb/clients.conf

####################################################################




####################################################################
###    SQL Configuration                                         ###
####################################################################
if [ -z "$RADIUS_DB_HOST" ]; then
  export RADIUS_DB_HOST=localhost
fi
if [ -z "$RADIUS_DB_PORT" ]; then
  export RADIUS_DB_PORT=3306
fi
if [ -z "$RADIUS_DB_USERNAME" ]; then
  export RADIUS_DB_USERNAME=radius
fi
if [ -z "$RADIUS_DB_PASSWORD" ]; then
  export RADIUS_DB_PASSWORD=radpass
fi
if [ -z "$RADIUS_DB_NAME" ]; then
  export RADIUS_DB_NAME=radius
fi

envsubst '
         ${RADIUS_DB_HOST}
         ${RADIUS_DB_PORT}
         ${RADIUS_DB_USERNAME}
         ${RADIUS_DB_PASSWORD}
         ${RADIUS_DB_NAME}
         ' < sql.template > /etc/raddb/mods-available/sql

if [ -z "$ENABLE_SQL" ]; then
  export ENABLE_SQL=""
else
  export ENABLE_SQL=sql
fi

envsubst '
         ${RADIUS_LISTEN_IP}
         $ENABLE_SQL
         ' < default.template > /etc/raddb/sites-available/default
envsubst '
         $ENABLE_SQL
         ' < inner-tunnel.template > /etc/raddb/sites-available/inner-tunnel

exec "$@"
