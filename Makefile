all: help

## |Setup, reset, and purge a local dev environment!

local/setup: 		## Setup local dev environment
	mkdir -p logs/nginx
	cat .env.example > .env
	make composer-install
	make up

local/reset:		## Delete container storage (includes restart)
	docker compose down -v
	make up

local/purge:		## Stop, delete container storage, composer dependencies, logs, and .env file
	docker compose down -v
	rm -rf  ./vendor .env ./logs

## |Container Management!

up:			## Start container
	docker compose up -d --remove-orphans

down:			## Stop container
	docker compose down

build:			## Build images
	docker compose build

## |Dependency management!

composer-install:	## Install composer dependencies
	docker compose run --rm composer

## |PHP XDebug!

xdebug/enable:		## Enable XDebug
	docker compose exec php-fpm docker-php-ext-enable xdebug
	docker compose exec php-fpm /bin/bash -c "kill -USR2 1"

xdebug/disable:		## Disable XDebug
	docker compose exec php-fpm docker-php-ext-disable-xdebug
	docker compose exec php-fpm /bin/bash -c "kill -USR2 1"

## 
help:			## Show this help.
	@echo "Usage: make OPTION\n"
	@echo "Options:"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST) | awk '{sub(":","");print}' | tr '|' '\n' | tr '!' ':'
	@echo
