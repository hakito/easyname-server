FROM php:5.6-apache

EXPOSE 80

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
		libbz2-dev libpng-dev libicu-dev libmcrypt-dev libpq-dev librecode-dev \
		libxml2-dev libxslt1-dev
    

RUN docker-php-ext-install bcmath bz2 calendar dba exif gd gettext intl mcrypt mysql mysqli pcntl pdo_mysql pdo_pgsql pgsql recode shmop soap sockets sysvmsg sysvsem sysvshm wddx xmlrpc xsl zip

WORKDIR "/tmp"

RUN curl 'https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz' -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Referer: https://www.ioncube.com/loaders/downloading.php?dload_link=https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7' -H 'Cookie: _ga=GA1.2.1614401997.1531561079; _gid=GA1.2.126538699.1531561079' --compressed > ioncube.tar.gz \
    && tar -xzf ioncube.tar.gz \
	&& cp ioncube/ioncube_loader_lin_5.6.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226 \
	&& rm -rf /tmp/*

RUN pecl install redis-2.2.5 \
    && rm -rf /tmp/* 	

COPY ionCube.ini /usr/local/etc/php/conf.d
COPY redis.ini /usr/local/etc/php/conf.d	

# Cleanup dev-packages and APT
RUN apt-get remove --auto-remove \
		libbz2-dev libpng-dev libicu-dev libmcrypt-dev libpq-dev librecode-dev \
		libxml2-dev libxslt1-dev \
	&& apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

WORKDIR "/var/www/html"	

#RUN /etc/init.d/apache2 reload