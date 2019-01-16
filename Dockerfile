FROM ubuntu:xenial

MAINTAINER Joel Herron <herronj@gmail.com>

# installing required stuff
RUN apt update \
    && apt-get install -y unzip \
    libaio-dev \
    libmcrypt-dev \
    git \
    wget \
    mc \
    curl \
    cron \
    zip \
    ldap-utils \
    libldap2-dev \
    && apt-get clean -y

## Install php7.0 extension
RUN apt-get install -yqq \
    php7.0-pgsql \
    php7.0-mysql \
    php7.0-opcache \
    php7.0-common \
    php7.0-mbstring \
    php7.0-mcrypt \
    php7.0-soap \
    php7.0-cli \
    php7.0-intl \
    php7.0-json \
    php7.0-xsl \
    php7.0-imap \
    php7.0-ldap \
    php7.0-curl \
    php7.0-gd \
    php7.0-zip \
    php7.0-dev \
    php7.0-fpm

# Oracle instantclient

	# copy oracle files
ADD oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip /tmp/
ADD oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip /tmp/
ADD oracle/instantclient-sqlplus-linux.x64-12.1.0.2.0.zip /tmp/
# unzip them
RUN unzip /tmp/instantclient-basic-linux.x64-12.1.0.2.0.zip -d /usr/local/ \
    && unzip /tmp/instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /usr/local/ \
    && unzip /tmp/instantclient-sqlplus-linux.x64-12.1.0.2.0.zip -d /usr/local/
# install pecl
RUN curl -O http://pear.php.net/go-pear.phar \
    ; /usr/bin/php -d detect_unicode=0 go-pear.phar
# install oci8
RUN ln -s /usr/local/instantclient_12_1 /usr/local/instantclient \
    && ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so \
    && ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus \
    && echo 'instantclient,/usr/local/instantclient' | pecl install oci8

COPY php-conf/php.ini /etc/php/7.0/cli/php.ini
