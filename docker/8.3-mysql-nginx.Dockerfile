FROM php:8.3-fpm-alpine3.20

WORKDIR /var/www
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    PATH="/var/www/vendor/bin:$PATH"
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
        curl-dev \
        openssl-dev && \
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
        nginx \
        mysql-client \
        libmemcached \
        libssh2 \
        zip \
        curl \
        libxml2 \
        libzip \
        gmp \
        linux-headers \
        bzip2 \
        openssl && \
    pecl install inotify && \
    pecl install redis-6.0.2 && \
    docker-php-ext-configure opcache --enable-opcache &&\
    docker-php-ext-configure gd --with-jpeg --with-webp --with-xpm --with-avif --with-freetype && \
    docker-php-ext-install \
        opcache \
        mysqli \
        pdo \
        pdo_mysql \
        sockets \
        intl \
        gd \
        exif \
        xml \
        bz2 \
        pcntl \
        bcmath \
        zip \
        soap \
        gmp \
        bcmath \
        ftp && \
    pecl install memcached-3.2.0 && \
    pecl install -a ssh2-1.4.1 && \
    docker-php-ext-enable \
        memcached \
        exif \
        redis \
        ssh2 \
        inotify && \
    curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer && \
    apk del --no-network .build-deps && \
    mkdir -p /run/php /run/nginx && \
    ln -s /dev/stdout /var/log/nginx/access.log && \
    ln -s /dev/stderr /var/log/nginx/error.log && \
    cp -v /mnt/usr/local/etc/php/php.ini /usr/local/etc/php/php.ini && \
    cp -v /mnt/usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d/ && \
    cp -v /mnt/usr/local/etc/php-fpm.d/* /usr/local/etc/php-fpm.d/ && \
    cp -v /mnt/etc/nginx/http.d/* /etc/nginx/http.d/ && \
    cp -Rv /mnt/etc/nginx/conf.d /etc/nginx/conf.d && \
    cp -v /mnt/etc/supervisord.conf /etc/supervisord.conf && \
    cd /tmp && \
    wget -O tasker.tar.gz https://github.com/adhocore/gronx/releases/download/v1.19.3/tasker_1.19.3_linux_amd64.tar.gz && \
    tar -xvf tasker.tar.gz && \
    mv tasker_*/tasker /usr/local/bin/tasker && \
    rm -frv tasker* && \
    echo "0 0 1 1 0 echo > /dev/null" > /etc/crontab

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
