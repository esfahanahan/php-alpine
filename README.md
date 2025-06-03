# PHP-Alpine
PHP running on alpine base Docker Image with or without Nginx 🐳


![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/esfahanahan/php-alpine/build-docker.yml?style=for-the-badge)
[![LICENSE](https://img.shields.io/github/license/esfahanahan/php-alpine.svg?style=for-the-badge)](https://github.com/esfahanahan/php-alpine/blob/master/LICENSE)
[![Stars Count](https://img.shields.io/github/stars/esfahanahan/php-alpine.svg?style=for-the-badge)](https://github.com/esfahanahan/php-alpine/stargazers)
[![Forks Count](https://img.shields.io/github/forks/esfahanahan/php-alpine.svg?style=for-the-badge)](https://github.com/esfahanahan/php-alpine/network/members)
[![Watchers Count](https://img.shields.io/github/watchers/esfahanahan/php-alpine.svg?style=for-the-badge)](https://github.com/esfahanahan/php-alpine/watchers)
[![Issues Count](https://img.shields.io/github/issues/esfahanahan/php-alpine.svg?style=for-the-badge)](https://github.com/esfahanahan/php-alpine/issues)
[![Pull Request Count](https://img.shields.io/github/issues-pr/esfahanahan/php-alpine.svg?style=for-the-badge)](https://github.com/esfahanahan/php-alpine/pulls)
[![Follow](https://img.shields.io/github/followers/esfahanahan.svg?style=for-the-badge&label=Follow&maxAge=2592000)](https://github.com/esfahanahan)


## Pull it from Github Registry
To pull the docker image:
```bash
docker pull ghcr.io/esfahanahan/php-alpine:8.3-mysql-nginx
```

## Usage
To run from current dir
```bash
docker run -v $(pwd):/var/www/html -p 80:80 ghcr.io/esfahanahan/php-alpine:8.3-mysql-nginx
```

## What's Included
 - [Composer](https://getcomposer.org/) ( v2 - updated )
 - [Tasker](https://github.com/adhocore/gronx) instead of CRON
 - [Go-Supervisor](https://github.com/QPod/supervisord) 

## Other Details
- Alpine base image

## PHP Extension
- bcmath
- bz2
- exif
- gd
- gmp
- intl
- mysqli
- opcache
- pcntl
- mysqli or pgsql
- pdo
- pdo_mysql or pdo_pgsql
- sockets
- xml
- zip


## Adding other PHP Extension
You can add additional PHP Extensions by running `docker-ext-install` command. Don't forget to install necessary dependencies for required extension.
```bash
FROM ghcr.io/esfahanahan/php-alpine:8.3-mysql-nginx
RUN docker-php-ext-install xdebug
```

## Adding a cronjob
```bash
FROM ghcr.io/esfahanahan/php-alpine:8.3-mysql-nginx
echo '0 * * * * /usr/local/bin/php  /var/www/artisan schedule:run >> /dev/null 2>&1' >> /etc/crontab
```
 
## Adding custom Supervisor config
You can add your own Supervisor config inside `/etc/supervisor.d/`. File extension needs to be `*.ini`. By default this image added `nginx`, `php-fpm` and `taker` process in supervisor. 

E.g: For a nodejs program you can make file `my-websocket-app.ini`
```ini
[program:my-websocket-app]
process_name=%(program_name)s
command=node /app/socket.js
autostart=true
autorestart=true
redirect_stderr=true
```
On your Docker image
```bash
FROM ghcr.io/esfahanahan/php-alpine:latest
ADD my-websocket-app.ini /etc/supervisor.d/
```
For more details please refrer to [QPod/supervisord](https://github.com/QPod/supervisord/blob/main/doc/doc-config.md) documentions.


## Bug Reporting

If you find any bugs, please report it by submitting an issue on our [issue page](https://github.com/esfahanahan/php-alpine/issues) with a detailed explanation. Giving some screenshots would also be very helpful.

## Feature Request

You can also submit a feature request on our [issue page](https://github.com/esfahanahan/php-alpine) or [discussions](https://github.com/esfahanahan/php-alpine/discussions) and we will try to implement it as soon as possible.

