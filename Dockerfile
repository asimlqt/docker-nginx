FROM nginx:1.9
MAINTAINER Elliot Wright <elliot@elliotwright.co>

# Hacky way to prevent substitution of variables we don't want to substitute
ENV ESCAPE="$"

# Configuration substitutions
ENV PHP_FPM_HOST php.docker
ENV PHP_FPM_PORT 9000
ENV PHP_HTTP_PORT 8080
ENV PHP_HTTPS_PORT 4430
ENV PHP_INDEX index.php

RUN \
    mkdir -p /opt/www && \
    mkdir -p /etc/nginx/ssl.d && \
    mkdir -p /etc/nginx/templates.d && \
    chown -R nginx: /opt/www && \
    openssl req -new -nodes -x509 -subj "/CN=*.docker.local/C=GB/ST=London/L=London/O=EWB" -days 3650 -keyout /etc/nginx/ssl.d/server.key -out /etc/nginx/ssl.d/server.crt -extensions v3_ca

COPY ./templates/default-php.template /etc/nginx/templates.d/

CMD /bin/bash -c "envsubst < /etc/nginx/templates.d/default-php.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
