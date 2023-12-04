#!/bin/sh
set -e

APP_DIR=/backend

# Configuração do cron
echo "* * * * * cd $APP_DIR && /usr/local/bin/php /backend/artisan schedule:run >> /backend/storage/logs/cron.log 2>&1" > /etc/crontabs/root

# Inicia o serviço cron em segundo plano
busybox crond -f -L /dev/null

# Inicia o seu aplicativo
exec "$@"
