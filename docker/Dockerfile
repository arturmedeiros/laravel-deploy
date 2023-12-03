FROM php:8.2-fpm-alpine

## Diretório da aplicação
ARG APP_DIR=/backend

# Instalação das extensões necessárias e pacote linux-headers
RUN set -ex \
    && apk --no-cache add \
        pcre-dev \
        ${PHPIZE_DEPS} \
        libzip-dev \
        linux-headers \
        nano \
    && docker-php-ext-install pdo_mysql pcntl sockets \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del pcre-dev ${PHPIZE_DEPS}

COPY . $APP_DIR

# Instala o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configure PHP
COPY ./docker/php/custom.ini /usr/local/etc/php/php.ini
COPY ./docker/php/extra-php-fpm.conf /etc/php8/php-fpm.d/www.conf

# Cria o diretório de logs e define permissões
RUN mkdir -p $APP_DIR/storage/logs \
    && chmod -R 777 $APP_DIR/storage

RUN chown -R www-data:www-data $APP_DIR/storage

# Setup Crontab
RUN touch crontab.tmp
RUN echo '* * * * * cd $APP_DIR && php /backend/artisan schedule:run >> /dev/null 2>&1' >> crontab.tmp
RUN crontab crontab.tmp
RUN rm -rf crontab.tmp

# Instalação do Supervisor
RUN apk add --no-cache supervisor
RUN touch /var/run/supervisord.sock \
    && touch /var/log/supervisord.log \
    && chmod 1777 /var/run

# Copia arquivo base de configuração do Supervisor
COPY ./docker/supervisord/supervisord.conf /etc/supervisord.conf

# Copia workers do projeto
RUN mkdir -p /etc/supervisor.d
COPY ./docker/supervisord/workers /etc/supervisor.d

# Set working directory
WORKDIR $APP_DIR
