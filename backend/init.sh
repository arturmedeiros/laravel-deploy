#!/bin/bash

# Aguardar até que o serviço MySQL esteja pronto
#until nc -z -w 1 database 3306
#do
#  echo "Aguardando o MySQL iniciar..."
#  sleep 1
#done

# Iniciar o Supervisor
#supervisord -c /etc/supervisord.conf
