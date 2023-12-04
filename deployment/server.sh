#!/bin/bash

clear
echo "=====================================================
 Microsservices (PHP 8.2, MySQL, Nginx & PHPMyAdmin)
-----------------------------------------------------
            Open Source Setup Project
    Author: Artur J Medeiros (https://arjos.eu)
====================================================="
echo "🏗️ Iniciando a instalação do seu projeto..."

docker info > /dev/null 2>&1

# Ensure that Docker is running...
if [ $? -ne 0 ]; then
    echo "O Docker não está rodando no seu servidor... Instalação não realizada!"
    exit 1
fi

# DEFAULT
IP=''
APP_PORT=8123
PMA_HOST=database
PMA_ADMIN_PORT=9999
DB_PORT=3306
DB_HOST=database
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=laravel
CACHE_DRIVER=redis
REDIS_PORT=6379

echo "⚙️  Configurando opções da aplicação..."
# IP
read -p "⚠️  Qual o endereço de IP do seu servodor? (Ex: 192.168.15.0) " resposta_ip
resposta_lower_ip=$(echo "$resposta_ip" | tr '[:upper:]' '[:lower:]')
if [[ $resposta_lower_ip ]]; then
    IP="$resposta_lower_ip"
else
    echo "$IP"
fi

# Configura APP_URL
APP_URL="http://${IP}:${APP_PORT}"

# APP_PORT
read -p "⚠️  Qual a porta que deseja rodar o seu projeto? (Ex: 8123) " resposta_port
resposta_lower_port=$(echo "$resposta_port" | tr '[:upper:]' '[:lower:]')
if [[ $resposta_lower_port ]]; then
    APP_PORT="$resposta_lower_port"
else
    echo "$APP_PORT"
fi

# PMA_HOST
read -p "⚠️  Qual a porta que deseja rodar o PHPMyAdmin? (Ex: 9999) " resposta_port_pma
resposta_lower_port_pma=$(echo "$resposta_port_pma" | tr '[:upper:]' '[:lower:]')
if [[ $resposta_lower_port_pma ]]; then
    PMA_ADMIN_PORT="$resposta_lower_port_pma"
else
    echo "$PMA_ADMIN_PORT"
fi

# DB_PORT
read -p "⚠️  Qual a porta que deseja rodar o seu Banco de Dados MySQL? (Ex: 3306) " resposta_port_db
resposta_lower_port_db=$(echo "$resposta_port_db" | tr '[:upper:]' '[:lower:]')
if [[ $resposta_lower_port_db ]]; then
    DB_PORT="$resposta_lower_port_db"
else
    echo "$DB_PORT"
fi

# DB_DATABASE
read -p "⚠️  Qual ao nome do seu banco de dados? (Ex: laravel) " resposta_db
resposta_lower_db=$(echo "$resposta_db" | tr '[:upper:]' '[:lower:]')
if [[ $resposta_lower_db ]]; then
    DB_DATABASE="$resposta_lower_db"
else
    echo "$DB_DATABASE"
fi

# DB_USERNAME
read -p "⚠️  Qual o nome de usuário do seu banco de dados? (Ex: laravel) " resposta_db_user
resposta_lower_db_user=$(echo "$resposta_db_user" | tr '[:upper:]' '[:lower:]')
if [[ $resposta_lower_db_user ]]; then
    DB_USERNAME="$resposta_lower_db_user"
else
    echo "$DB_USERNAME"
fi

# DB_PASSWORD
read -p "⚠️  Qual a senha do seu banco de dados? (Ex: laravel) " resposta_db_pwd
resposta_lower_db_pwd=$(echo "$resposta_db_pwd" | tr '[:upper:]' '[:lower:]')
if [[ $resposta_lower_db_pwd ]]; then
    DB_PASSWORD="$resposta_lower_db_pwd"
else
    echo "$DB_PASSWORD"
fi


# REDIS_PORT
read -p "⚠️  Qual a porta que deseja rodar o seu REDIS? (Ex: 6379) " resposta_port_redis
resposta_lower_port_redis=$(echo "$resposta_port_redis" | tr '[:upper:]' '[:lower:]')
if [[ $resposta_lower_port_redis ]]; then
    DB_PORT="$resposta_lower_port_redis"
else
    echo "$DB_PORT"
fi

# Baixa Repo
echo "📦  Baixando repositório..."
#git clone https://github.com/arturmedeiros/laravel-deploy.git
echo "✅  Etapa concluída!"

## Permissão na pasta
echo "🔒 Concedendo permissões..."
chmod +x laravel-deploy
sudo chmod 777 -R laravel-deploy/backend/
echo "✅  Etapa concluída!"

# Cria o .env do projeto Laravel
echo "🔥  Configurando projeto..."

if [ -f "laravel-deploy/.env" ]; then
    rm -R laravel-deploy/.env
fi

# Copia a base padrão do .env do Laravel
cp laravel-deploy/backend/.env.deployment laravel-deploy/backend/.env

# Adiciona variáveis no novo arquivo .env.example
echo "
APP_PORT=${APP_PORT}
APP_URL=${APP_URL}
DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
DB_DATABASE=${DB_DATABASE}
DB_USERNAME=${DB_USERNAME}
DB_PASSWORD=${DB_PASSWORD}
PMA_ADMIN_PORT=${PMA_ADMIN_PORT}
REDIS_PORT=${REDIS_PORT}
" >> laravel-deploy/backend/.env

# Cria Docker Compose Padrão
if [ -f "laravel-deploy/docker-compose.yaml" ]; then
    rm -R laravel-deploy/docker-compose.yaml
fi

echo "version: '3.9'

networks:
  ms_network:
    driver: bridge

services:
  backend:
    image: laravel
    container_name: backend
    restart: always
    build:
      context: .
      dockerfile: docker/Dockerfile
    volumes:
      - ./backend:/backend
    depends_on:
      - database
    networks:
      - ms_network

  nginx:
    image: nginx:latest
    container_name: nginx
    volumes:
      - ./docker/nginx/nginx.conf:/etc/nginx/conf.d/default.conf
    ports:
      - ${APP_PORT:-8123}:80
    networks:
      - ms_network
    depends_on:
      - backend

  database:
    image: mariadb:10.7
    container_name: database
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD-laravel}
      MYSQL_DATABASE: ${DB_DATABASE-laravel}
      MYSQL_USER: ${DB_USERNAME-laravel}
      MYSQL_PASSWORD: ${DB_PASSWORD-laravel}
    volumes:
      - ./database/mysql:/var/lib/mysql
    networks:
      - ms_network

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin
    restart: always
    environment:
      PMA_HOST: database
      PMA_PORT: ${DB_PORT-3306}
      PMA_ARBITRARY: 1
      PMA_CONTROLHOST: database
      PMA_CONTROLPORT: ${DB_PORT-3306}
    volumes:
      - ./docker/php/custom.ini:/usr/local/etc/php/conf.d/uploads.ini
    ports:
      - ${PMA_PORT-9999}:80
    depends_on:
      - database
    networks:
      - ms_network

  redis:
    image: redis:latest
    container_name: redis
    restart: always
    depends_on:
      - backend
    ports:
      - ${REDIS_PORT-6379}:6379
    networks:
      - ms_network
" > laravel-deploy/docker-compose.yaml
echo "✅  Etapa concluída!"

# Colocar de forma mais permanente
echo "🚀  Inicializando aplicações..."
cd laravel-deploy/ && docker-compose up --build -d

# Acessa container do Laravel e faz o setup necessário
docker exec backend composer install \
    && docker exec backend php artisan key:generate --force \
    && docker exec backend php artisan jwt:secret --force \
    && docker exec backend php artisan storage:link \
    && docker exec backend php artisan queue:table \
    && docker exec backend php artisan migrate --seed --force

echo "✅  Etapa concluída!"

echo "
=======================================================
  ACESSE SUA APLICAÇÃO!
-------------------------------------------------------
  Sua aplicação: ${APP_URL}
  PHPMyAdmin: http://${IP}:${PMA_ADMIN_PORT}
=======================================================
"

# Steps:
# 1) nano server.sh
# 2) chmod +x server.sh
# 3) bash ./server.sh

# Automático
# curl -s "https://raw.githubusercontent.com/arturmedeiros/laravel-deploy/master/deployment/server.sh" | bash

# Personalizado
# bash <(curl -s "https://raw.githubusercontent.com/arturmedeiros/laravel-deploy/master/deployment/server.sh")
