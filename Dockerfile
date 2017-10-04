FROM eu.gcr.io/brave-sunspot-181810/nginx-php7-fpm:0.1.0

MAINTAINER Artur Melo <adsmelo.dev.ops@gmail.com>

RUN mkdir -p /srv/project/var/cache && chmod 777 /srv/project/var/cache
RUN mkdir -p /srv/project/var/logs && chmod 777 /srv/project/var/logs

WORKDIR /srv/project/

# Allow access to all env vars for the PHP-FPM workers
RUN sed -e 's/;clear_env = no/clear_env = no/' -i /etc/php/${IMAGE_PHP_VERSION}/fpm/pool.d/www.conf

# Copy some needed contents from project
COPY ./bin /srv/project/bin
COPY ./web /srv/project/web
COPY ./app/AppKernel.php /srv/project/app/AppKernel.php
COPY ./composer.* /srv/project/

# Install other vendor libs/dependencies
RUN SYMFONY_ENV=prod composer install --no-dev --no-interaction --quiet

# Copy the remaining files from project
COPY ./app /srv/project/app
COPY ./src /srv/project/src

# Build bootstrap and generate the necessary assets
RUN SYMFONY_ENV=prod composer symfony-scripts
