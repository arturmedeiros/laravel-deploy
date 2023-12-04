<div align="center">
<a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400"></a>
</div>

# Laravel Docker-compose Boilerplate ```by ARJOS```
### Bônus: REST API with JWT Authentication
![Laravel](https://img.shields.io/badge/10.10-100000?label=Laravel&style=for-the-badge&logo=laravel&color=f20000)
![PHP](https://img.shields.io/badge/8.2-100000?label=PHP&style=for-the-badge&logo=php&color=007bff)
![Docker](https://img.shields.io/badge/Docker-000?&style=for-the-badge&logo=Docker&color=555)
![MySQL](https://img.shields.io/badge/MySQL-000?style=for-the-badge&logo=MySQL&color=555)
![PHPMyAdmin](https://img.shields.io/badge/PHPMyAdmin-000?style=for-the-badge&logo=PHPMyAdmin&color=555)

Run Laravel 10 project (FPM/NGINX & Octane/Swoole) using Docker and Docker-compose.

### It includes:
* Laravel JWT Authentication.
* Functional Project with API Routes.
* PHP v8.2.
* Separate docker-compose files for FPM/NGINX.
* MySQL v10.
* Redis v7.
* PHP MyAdmin.
* Supervisord.
* Configured Crontab for running Scheduled Tasks.
* Example of a Laravel command used in a scheduled task.

## ✅ Requirements

- Docker;
- Docker Compose.

---

## Development

#### Boot locally first time
```shell
cd .. && bash <(curl -s "https://raw.githubusercontent.com/arturmedeiros/laravel-deploy/master/deployment/server.sh?v=1") \
    && docker exec backend composer install \
    && docker exec backend php artisan key:generate --force \
    && docker exec backend php artisan jwt:secret --force \
    && docker exec backend php artisan storage:link \
    && docker exec backend php artisan queue:table \
    && docker exec backend php artisan migrate --seed --force
```

#### Start Docker Containers
````shell
docker-compose up --build -d
````

#### Access bash from Laravel container
```shell
docker exec -it backend sh
```

#### Activate Supervisor and Schedules Tasks Cron
```shell
docker exec backend supervisord -c /etc/supervisord.conf \
  && docker exec backend /usr/sbin/crond -l10
```

## 🧑🏻‍💻 Author

- [@arturmedeiros](https://www.github.com/arturmedeiros)

## ⚖️ License
MIT License

Copyright (c) 2023 @ARTURMEDEIROS - ARJOS.EU

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
