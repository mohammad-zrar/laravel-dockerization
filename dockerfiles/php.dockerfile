FROM php:8.3-fpm-alpine3.21

WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql


