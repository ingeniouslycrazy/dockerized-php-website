all: build composer-install up

# Container management: start
up:
	docker compose up -d --remove-orphans

# Container management: stop
down:
	docker compose down

# Container management: build images
build:
	docker compose build

# Dependency management
composer-install:
	docker compose run --rm composer

# Setup local dev environment
local/setup:
	mkdir -p logs/nginx
	cat .env.example > .env
	make composer-install
	make up

# Reset volume storage for services and remove anything installed by this script
local/purge:
	docker compose down -v
	rm -rf  ./vendor .env ./logs

# Reset volume storage for services
local/reset:
	docker compose down -v
	make up

# XDebug: enable
xdebug/enable:
	docker compose exec php-fpm docker-php-ext-enable xdebug
	docker compose exec php-fpm /bin/bash -c "kill -USR2 1"

# XDebug: disable
xdebug/disable:
	docker compose exec php-fpm docker-php-ext-disable-xdebug
	docker compose exec php-fpm /bin/bash -c "kill -USR2 1"
