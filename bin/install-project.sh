#!/bin/bash

# Clean up existing docker data -For clean installation
docker-compose down

rm -rf laravel
rm -rf docker/laravel
rm -rf docker/db/dbdata

docker-compose down 

# OPTION 1
# -------------------- #
# Download laravel LTS framework (https://github.com/laravel/laravel/releases)
#LARAVEL_VERSION_NO="5.5.28"
#curl -L https://github.com/laravel/laravel/archive/v${LARAVEL_VERSION_NO}.tar.gz | tar xz
#mv laravel-${LARAVEL_VERSION_NO} docker/laravel
#cp docker/laravel/.env.example docker/laravel/.env
# -------------------- #

# OPTION 2
# -------------------- #
# OR clone your existing project

git clone https://github.com/geoinca/laravelminio.git laravel 
echo "git done"
mv laravel  docker/laravel
echo "laravel mode"
# Checkout whitapache branch for local development purpose
#cd laravel
#git checkout whitapache
#cd ..
# -------------------- #
cp .env docker/laravel
echo "cp env done"
# Create image
docker-compose up --build -d
echo "docker-compose up done"
# Perform series of action in container
APP_NAME="laravel-phpfpm"

docker-compose exec $APP_NAME composer install

docker-compose exec $APP_NAME php artisan key:generate

docker-compose exec $APP_NAME node -v

docker-compose exec $APP_NAME npm install

docker-compose exec $APP_NAME npm run dev

# Ensure database is ready to handel php artisan command
sleep 3

docker-compose exec $APP_NAME php artisan optimize

docker-compose exec $APP_NAME php artisan migrate:refresh --seed

docker-compose exec $APP_NAME vendor/bin/phpunit


# Folder Permissions
docker-compose exec $APP_NAME chmod 777 -R /var/www/laravel/storage/logs/

docker-compose exec $APP_NAME chmod 777 -R /var/www/laravel/storage/framework/sessions

docker-compose exec $APP_NAME chmod 777 -R /var/www/laravel/storage/framework/views

