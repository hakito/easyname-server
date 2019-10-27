FROM php:apache

RUN apt-get update && \
    apt-get install -y \
        git \
        zip \
        zlib1g-dev \
        libzip-dev \
        libicu-dev \
        g++ \
    && docker-php-ext-install zip mysqli pdo_mysql intl

RUN pecl install -f xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini;

RUN apt-get remove -y \
        zlib1g-dev \
        libzip-dev \
        libicu-dev \
        g++

RUN rm -rf /var/lib/apt/lists/*

# enabling mod_rewrite
RUN a2enmod rewrite
RUN service apache2 restart