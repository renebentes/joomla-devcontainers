FROM joomla:${templateOption:imageVariant}

# Install MariaDB client
RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y mariadb-client; \
    apt-get clean -y; \
    rm -rf /var/lib/apt/lists/*

# Install composer
RUN curl -sSL https://getcomposer.org/installer | php \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer

# Install xdebug
RUN yes | pecl install xdebug \
    && echo "zend_extension = $(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.client_port = 9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && rm -rf /tmp/pear
