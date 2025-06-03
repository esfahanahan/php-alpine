FROM php:8.3-cli-alpine3.20

LABEL org.opencontainers.image.title="PHP 8.3 with PostgreSQL, Composer, Tasker, and Supervisor"
LABEL org.opencontainers.image.description="PHP 8.3 with PostgreSQL, Composer, Tasker, and Supervisor including extensions: (bcmath, bz2, exif, gd, gmp, intl, mysqli, opcache, pcntl, pdo, pdo_pgsql, sockets, xml, zip, inotify, exif, memcached, redis) based on php:8.3-cli-alpine3.20"

WORKDIR /var/www

ARG TASKER_VERSION=1.19.3

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    PATH="/var/www/vendor/bin:$PATH"

COPY --from=composer:2.8 /usr/bin/composer /usr/local/bin/composer
COPY --from=qpod/supervisord:alpine /opt/supervisord/supervisord /usr/bin/supervisord

RUN --mount=type=bind,source=fs,target=/mnt apk add --no-cache --virtual .build-deps $PHPIZE_DEPS  \
        zlib-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libxpm-dev \
        libavif-dev \
        libxml2-dev \
        bzip2-dev \
        libmemcached-dev \
        libssh2-dev \
        libzip-dev \
        freetype-dev \
        gmp-dev \
        curl-dev && \
    apk add --update --no-cache \
        libpng \
        libwebp \
        libxpm \
        libavif \
        jpegoptim \
        pngquant \
        optipng \
        nano \
        icu-dev \
        freetype \
        libmemcached \
        postgresql-dev \
        libssh2 \
        zip \
        curl \
        libxml2 \
        libzip \
        gmp \
        linux-headers \
        bzip2 && \
    pecl install inotify && \
    pecl install redis-6.0.2 && \
    docker-php-ext-configure opcache --enable-opcache &&\
    docker-php-ext-configure gd --with-jpeg --with-webp --with-xpm --with-avif --with-freetype && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-install \
        bcmath \
        bz2 \
        exif \
        gd \
        gmp \
        intl \
        mysqli \
        opcache \
        pcntl \
        pdo \
        pdo_pgsql \
        sockets \
        xml \
        zip && \
    pecl install memcached-3.2.0 && \
    docker-php-ext-enable \
        inotify \
        exif \
        memcached \
        redis && \
    apk del --no-network .build-deps && \
    mkdir -p /run/php /etc/supervisor/conf.d/ && \
    cp -v /mnt/usr/local/etc/php/php.ini /usr/local/etc/php/php.ini && \
    cp -v /mnt/usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d/ && \
    cp -v /mnt/etc/supervisor/supervisord.conf /etc/supervisor/supervisord.conf && \
    cp -v /mnt/etc/supervisor/conf.d/10-tasker.conf /etc/supervisor/conf.d/10-tasker.conf && \
    touch /var/log/supervisord.log && \
    cd /tmp && \
    wget -O tasker.tar.gz https://github.com/adhocore/gronx/releases/download/v${TASKER_VERSION}/tasker_${TASKER_VERSION}_linux_amd64.tar.gz && \
    tar -xvf tasker.tar.gz && \
    mv tasker_*/tasker /usr/local/bin/tasker && \
    rm -frv tasker* && \
    echo "0 0 1 1 0 echo > /dev/null" > /etc/crontab

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
