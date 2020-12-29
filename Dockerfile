FROM wyveo/nginx-php-fpm:php80

WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install --yes \
    apt-utils \
    bash-completion \
    gnupg2 \
    lsb-release \
    curl \
    zip \
    unzip \
    vim \
    wget \
    procps \
    nginx \
    default-mysql-client

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
# RUN docker-php-ext-install pdo_mysql

# Copy all service config files to container
COPY ./.docker/nginx.conf /etc/nginx/nginx.conf
COPY ./.docker/default.conf /etc/nginx/conf.d/default.conf
COPY ./.docker/php.ini /usr/local/etc/php/php.ini

# Get latest Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --version=1.10.19
RUN mv composer.phar /bin/composer
RUN php -r "unlink('composer-setup.php');"

EXPOSE 8088

## CMD /usr/sbin/nginx \
##    && /usr/local/sbin/php-fpm
