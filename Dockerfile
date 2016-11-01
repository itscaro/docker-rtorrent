FROM alpine:edge

MAINTAINER Minh-Quan TRAN <account@itscaro.me>

RUN apk add --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --no-cache\
    rtorrent \
    nginx \
    php7 \
    php7-fpm \
    php7-json \
    curl \
    gzip \
    zip \
    unrar \
    supervisor \
    geoip \
    ffmpeg


RUN curl -o rutorrent.zip -L https://github.com/Novik/ruTorrent/archive/master.zip \
    && unzip rutorrent.zip -d /tmp/ && mv /tmp/ruTorrent-master /rutorrent && rm rutorrent.zip \
    && mkdir -p /tmp/nginx/client-body /downloads/incoming /downloads/completed /downloads/watched /downloads/sessions /tmp/rtorrent \
    && adduser -D -h / -u 5001 rtorrent \
    && chown -R rtorrent:rtorrent /downloads /rutorrent /tmp/rtorrent /var/lib/nginx \
    && sed -i \
        -e 's/group =.*/group = rtorrent/' \
        -e 's/user =.*/user = rtorrent/' \
        -e 's/listen\.owner.*/listen\.owner = rtorrent/' \
        -e 's/listen\.group.*/listen\.group = rtorrent/' \
        -e 's/error_log =.*/error_log = \/dev\/stdout/' \
        /etc/php7/php-fpm.d/www.conf \
    && sed -i \
        -e '/open_basedir =/s/^/\;/' \
        /etc/php7/php.ini \
    && sed -i \
        -e "/curl/ s/''/'\/usr\/bin\/curl'/" \
        -e "/php/ s/''/'\/usr\/bin\/php7'/" \
        /rutorrent/conf/config.php

ADD supervisord.conf /etc/supervisor.d/supervisord.ini

ADD nginx.conf /etc/nginx/nginx.conf

ADD rtorrent.conf /.rtorrent.rc

ADD run.sh /run.sh

VOLUME /downloads /rutorrent /etc/nginx/conf.d

EXPOSE 80 5000 6881 51413

CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
