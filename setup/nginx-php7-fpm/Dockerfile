# See https://github.com/byrnedo/docker-nginx-php7-fpm/blob/0.1.8/Dockerfile
FROM byrnedo/nginx-php7-fpm:0.1.8

MAINTAINER Artur Melo <adsmelo.dev.ops@gmail.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
# Disables the warning about running commands as root/super user...
#  should really only set this if you use Composer as super user at all times like in docker containers.
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get update &&\
    apt-get install -y --no-install-recommends unzip &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set timezone
RUN rm /etc/localtime &&\
    ln -s /usr/share/zoneinfo/Europe/Lisbon /etc/localtime &&\
    "date"

# Set timezone for PHP in configurations
RUN echo "date.timezone='Europe/Lisbon'" > /etc/php/${IMAGE_PHP_VERSION}/cli/conf.d/timezone.ini

# hirak/prestissimo enables parallelization of composer dependencies download
RUN composer global require hirak/prestissimo "0.3.7" --no-interaction --quiet

ENV NGINX_ROOT /srv/project/web
COPY symfony.conf /etc/nginx/sites-available/default.conf

WORKDIR /srv/project/
