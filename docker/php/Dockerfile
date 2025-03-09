FROM php:8.3-fpm

# PHP extensions
RUN docker-php-ext-install pdo pdo_mysql

# Enable debug
RUN pecl install xdebug

COPY . /var/www/html

COPY ./docker/php/bin /usr/local/bin
