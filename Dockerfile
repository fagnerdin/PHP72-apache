FROM php:7.2-apache-buster
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y libmcrypt-dev libbz2-dev libxml2-dev libxslt-dev libgmp-dev libldap2-dev libc-client-dev libkrb5-dev \
    && apt-get install -y libmagickwand-dev --no-install-recommends  \
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libz-dev libmemcached-dev \
    && rm -rf /var/lib/apt/lists/*
    
RUN a2enmod ssl && a2enmod rewrite && docker-php-ext-install sysvmsg sysvsem sysvshm wddx xmlrpc opcache tokenizer \
    bcmath bz2 calendar exif gettext gmp intl mbstring shmop soap sockets xsl pdo pdo_mysql json hash iconv

RUN pecl install apcu && docker-php-ext-enable apcu \
    && pecl install igbinary && rm -rf /tmp/pear && docker-php-ext-enable igbinary\
    && pecl install imagick && docker-php-ext-enable imagick \
    && pecl install mcrypt && docker-php-ext-enable mcrypt \
    && pecl install memcached && docker-php-ext-enable memcached

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu && docker-php-ext-install ldap && apt-get purge -y --auto-remove libldap2-dev
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install imap && docker-php-ext-enable imap
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir=/usr/include/ && docker-php-ext-install gd && docker-php-ext-enable gd
