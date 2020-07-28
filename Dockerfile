FROM php:apache

RUN apt update && \
    apt install -y \
        git \
        zip \
        zlib1g-dev \
        libzip-dev \
        libicu-dev \
        g++ \
        libxml2-dev \
        libpng-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install zip mysqli pdo_mysql intl soap gd

RUN pecl install -f xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini;
    && echo "memory_limit=256M" > /usr/local/etc/php/conf.d/memory.ini;

RUN apt remove -y \
        zlib1g-dev \
        libzip-dev \
        libicu-dev \
        g++ \
        libxml2-dev \
        libpng-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev

RUN rm -rf /var/lib/apt/lists/*

# enabling mod_rewrite
RUN a2enmod rewrite
RUN service apache2 restart
