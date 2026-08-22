# values: 8.2, 8.3, 8.4, 8.5
ARG PHP_VERSION=8.5

FROM php:${PHP_VERSION}-cli-alpine3.24

LABEL org.opencontainers.image.title="PHP ${PHP_VERSION} with MySQL, Composer, Tasker, and Supervisor"
LABEL org.opencontainers.image.description="PHP ${PHP_VERSION} with MySQL, Composer, Tasker, and Supervisor including extensions: (bcmath, exif, gd, intl, opcache, pcntl, pdo, pdo_mysql, redis, soap, sockets, xml, zip) based on php:${PHP_VERSION}-cli-alpine3.24"

WORKDIR /var/www

ARG TASKER_VERSION=1.20.3
ARG COMPOSER_VERSION=2.10.2

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    PATH="/var/www/vendor/bin:$PATH"

COPY --from=qpod/supervisord:alpine /opt/supervisord/supervisord /usr/bin/supervisord

RUN --mount=type=bind,source=fs,target=/mnt/fs \
    curl \
        --silent \
        --fail \
        --location \
        --retry 3 \
        --output /tmp/installer.php \
        --url https://raw.githubusercontent.com/composer/getcomposer.org/f24b8f860b95b52167f91bbd3e3a7bcafe043038/web/installer && \
    php /tmp/installer.php \
        --no-ansi \
        --install-dir=/usr/bin \
        --filename=composer \
        --version=${COMPOSER_VERSION} && \
    rm -rf /tmp/installer.php && \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
        curl-dev \
        freetype-dev \
        icu-dev \
        libavif-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libxml2-dev \
        libxpm-dev \
        libzip-dev \
        linux-headers \
        openssl-dev \
        zlib-dev && \
    apk add --update --no-cache \
        curl \
        freetype \
        icu-data-full \
        icu-libs \
        jpegoptim \
        libavif \
        libjpeg-turbo \
        libpng \
        libwebp \
        libxml2 \
        libxpm \
        libzip \
        mysql-client \
        nano \
        optipng \
        pngquant \
        shadow \
        zip && \
    pecl install redis-6.3.0 && \
    docker-php-ext-configure opcache && \
    docker-php-ext-configure gd --with-avif --with-freetype --with-jpeg --with-webp --with-xpm && \
    docker-php-ext-install \
        bcmath \
        exif \
        gd \
        intl \
        opcache \
        pcntl \
        pdo \
        pdo_mysql \
        soap \
        sockets \
        xml \
        zip && \
    docker-php-ext-enable redis && \
    apk del --no-network .build-deps && \
    mkdir -p /run/php /etc/supervisor/conf.d/ /var/log/supervisor/ && \
    cp -v /mnt/fs/usr/local/bin/* /usr/local/bin/ && \
    cp -v /mnt/fs/usr/local/etc/php/php.ini /usr/local/etc/php/php.ini && \
    cp -v /mnt/fs/usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d/ && \
    cp -v /mnt/fs/etc/supervisor/supervisord.conf /etc/supervisor/supervisord.conf && \
    cp -v /mnt/fs/etc/supervisor/conf.d/10-tasker.conf /etc/supervisor/conf.d/10-tasker.conf && \
    touch /var/log/supervisord.log && \
    chown -R www-data:www-data /var/www/ /var/log/supervisor/ /var/log/supervisord.log && \
    cd /tmp && \
    wget -O tasker.tar.gz https://github.com/adhocore/gronx/releases/download/v${TASKER_VERSION}/tasker_${TASKER_VERSION}_linux_amd64.tar.gz && \
    tar -xvf tasker.tar.gz && \
    mv tasker_*/tasker /usr/local/bin/tasker && \
    rm -frv tasker* && \
    echo "0 0 1 1 0 echo > /dev/null" > /etc/crontab

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
