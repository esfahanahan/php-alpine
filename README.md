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
`php-alpine` is the image name. It does not include the Alpine release, so that release is a suffix on the tag, the same place the official PHP image puts it (`8.5.12-cli-alpine3.24`).

One build is pushed to four tags. `8.5-mysql-nginx` and `8.5.12-mysql-nginx` are the same image: the minor tag follows the newest patch, and the patch tag is the one to pin when a deploy must include a specific PHP security release. Variants are `mysql`, `mysql-nginx`, `pgsql`, and `pgsql-nginx`.

| Tag | Example | When it moves |
| --- | --- | --- |
| `<minor>-<variant>` | `8.5-mysql-nginx` | Next PHP patch, or the next Alpine version in the build matrix |
| `<patch>-<variant>` | `8.5.12-mysql-nginx` | Rebuilds of this PHP patch. Stops moving once the workflow pin leaves 8.5.12 |
| `<minor>-<variant>-alpine<version>` | `8.5-mysql-nginx-alpine3.24` | Next PHP patch, while this Alpine release is still the one being built |
| `<patch>-<variant>-alpine<version>` | `8.5.12-mysql-nginx-alpine3.24` | Same rebuilds. The name stays on Alpine 3.24 after a later Alpine bump |

```bash
docker pull ghcr.io/esfahanahan/php-alpine:8.5-mysql-nginx
docker pull ghcr.io/esfahanahan/php-alpine:8.5.12-mysql-nginx
docker pull ghcr.io/esfahanahan/php-alpine:8.5.12-mysql-nginx-alpine3.24
```

PHP lines currently built, including the fixes for CVE-2026-109618 and CVE-2026-109619: `8.2.35`, `8.3.36`, `8.4.27`, `8.5.12` on Alpine 3.24. There is no `latest` tag. Pin a digest when a deploy must not change on rebuild.

## Usage
To run from current dir
```bash
docker run -v $(pwd):/var/www/html -p 80:80 ghcr.io/esfahanahan/php-alpine:8.5-mysql-nginx
```

## What's Included
 - [Composer](https://getcomposer.org/) ( v2 - updated )
 - [Tasker](https://github.com/adhocore/gronx) instead of CRON
 - [Go-Supervisor](https://github.com/QPod/supervisord) 

## Other Details
- Alpine base image

## PHP Extension
- bcmath
- exif
- gd
- intl
- opcache
- pcntl
- pdo
- pdo_mysql or pdo_pgsql
- redis
- soap
- sockets
- xml
- zip


## Adding other PHP Extension
You can add additional PHP Extensions by running `docker-ext-install` command. Don't forget to install necessary dependencies for required extension.
```bash
FROM ghcr.io/esfahanahan/php-alpine:8.5-mysql-nginx
RUN docker-php-ext-install xdebug
```

## Adding a cronjob
```bash
FROM ghcr.io/esfahanahan/php-alpine:8.5-mysql-nginx
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
FROM ghcr.io/esfahanahan/php-alpine:8.5-mysql-nginx
ADD my-websocket-app.ini /etc/supervisor.d/
```
For more details please refrer to [QPod/supervisord](https://github.com/QPod/supervisord/blob/main/doc/doc-config.md) documentions.


## Bug Reporting

If you find any bugs, please report it by submitting an issue on our [issue page](https://github.com/esfahanahan/php-alpine/issues) with a detailed explanation. Giving some screenshots would also be very helpful.

## Feature Request

You can also submit a feature request on our [issue page](https://github.com/esfahanahan/php-alpine) or [discussions](https://github.com/esfahanahan/php-alpine/discussions) and we will try to implement it as soon as possible.

