FROM nimmis/alpine:3.4
MAINTAINER Alexis Tyler <xo@wvvw.me>

RUN apk update && apk upgrade && \
    apk add curl && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /tmp/caddy \
 && curl -sL -o /tmp/caddy/caddy_linux_amd64.tar.gz "https://caddyserver.com/download/build?os=linux&arch=amd64&features=awslambda%2Ccors%2Cexpires%2Cfilemanager%2Cfilter%2Cgit%2Chugo%2Cipfilter%2Cjsonp%2Cjwt%2Clocale%2Cmailout%2Cminify%2Cmultipass%2Cprometheus%2Cratelimit%2Crealip%2Csearch%2Cupload" \
 && tar -zxf /tmp/caddy/caddy_linux_amd64.tar.gz -C /tmp/caddy \
 && mv /tmp/caddy/caddy /usr/bin/ \
 && chmod +x /usr/bin/caddy \
 && rm -rf /tmp/caddy

ENV DOCKER_GEN_VERSION 0.4.3

RUN curl -sL -o docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

RUN printf ":80\nproxy / caddyserver.com" > /etc/Caddyfile

ADD etc /etc

ENV DOCKER_HOST unix:///tmp/docker.sock
ENV CADDY_OPTIONS ""
