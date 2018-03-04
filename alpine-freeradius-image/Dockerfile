# Radius Service base Alpine 
FROM alpine:3.7

MAINTAINER @aliasmee

ARG BUILD_DEPS="gettext mysql-client"

ARG RUNTIME_DEPS="libintl"

RUN apk update && apk upgrade && \
    apk add --update freeradius freeradius-radclient freeradius-mysql bash && \
    apk add --update $RUNTIME_DEPS && apk add --virtual build_deps $BUILD_DEPS && \
    chgrp radius /usr/sbin/radiusd && cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    cp /usr/bin/mysql /usr/sbin/mysql && \
    chmod g+rwx /usr/sbin/radiusd && apk del build_deps && rm /var/cache/apk/*

RUN ln -s /etc/raddb/mods-available/sql /etc/raddb/mods-enabled/sql

ADD docker-entrypoint.sh docker-entrypoint.sh
ADD conf/default.template default.template
ADD conf/inner-tunnel.template inner-tunnel.template
ADD conf/radiusd.conf.template radiusd.conf.template
ADD conf/clients.conf.template clients.conf.template
ADD conf/sql.template sql.template

EXPOSE 1812/udp 1813/udp 18120/udp

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["/usr/sbin/radiusd", "-xx", "-f"]
