FROM php:7.4.10-fpm-buster
LABEL maintainer="yuazuma"
COPY php.ini /usr/local/etc/php/

RUN apt-get update \
  && apt-get install -y --no-install-recommends libzip4 libzip-dev mariadb-client unzip zlib1g-dev \
  && docker-php-ext-install zip pdo_mysql

RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd exif

# Composerインストール
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
  php composer-setup.php && \
  php -r "unlink('composer-setup.php');" && \
  mv composer.phar /usr/local/bin/composer

# Node/npmインストール
RUN apt-get update && \
  apt-get install -y curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN npm install npm@latest -g

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV COMPOSER_MEMORY_LIMIT=-1

ENV PATH $PATH:/composer/vendor/bin


WORKDIR /var/www

RUN composer global require "laravel/installer"
RUN rm -rf html && \
  composer create-project --prefer-dist laravel/laravel=7.* .

RUN sed -i -e 's/DB_HOST=127.0.0.1/DB_HOST=dbc/' .env && \
  sed -i -e 's/DB_DATABASE=laravel/DB_DATABASE=DATABASENAME/' .env && \
  sed -i -e 's/DB_USERNAME=root/DB_USERNAME=USERNAME/' .env && \
  sed -i -e 's/DB_PASSWORD=/DB_PASSWORD=USERPASSWORD/' .env && \
  sed -i -e 's/APP_URL=http:\/\/localhost/APP_URL=http:\/\/example.com/' .env && \
  cat .env

RUN chmod 777 -R storage && \
  chmod 777 -R bootstrap/cache

# Laravel7用の認証機能をセットアップ
RUN composer require laravel/ui:^2.4 && \
  php artisan ui vue --auth && \
  npm install && \
  npm run dev

# 便利ツール群
RUN composer require doctrine/dbal && \
  composer require --dev barryvdh/laravel-debugbar

# Voyager
RUN composer require "tcg/voyager"
