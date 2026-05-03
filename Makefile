COMPOSE := docker compose
SERVICE := mysql
-include .env
MYSQL_ROOT_PASSWORD ?= root_password
MYSQL_DATABASE ?= mysql_datatypes
MYSQL_ROOT := $(COMPOSE) exec -T -e MYSQL_PWD=$(MYSQL_ROOT_PASSWORD) $(SERVICE) mysql --default-character-set=utf8mb4 -u root

.DEFAULT_GOAL := help

.PHONY: help up down restart logs ps pull mysql version init json clean

help:
	@echo Доступные команды:
	@echo   make up       - запустить MySQL
	@echo   make down     - остановить контейнеры
	@echo   make restart  - перезапустить MySQL
	@echo   make logs     - показать логи MySQL
	@echo   make ps       - показать статус контейнеров
	@echo   make pull     - скачать образ MySQL
	@echo   make mysql    - открыть консоль MySQL
	@echo   make version  - показать версию MySQL в контейнере
	@echo   make init     - заново применить учебную схему и тестовые данные
	@echo   make json     - выполнить примеры запросов по JSON
	@echo   make clean    - остановить контейнеры и удалить volume

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

restart: down up

logs:
	$(COMPOSE) logs -f $(SERVICE)

ps:
	$(COMPOSE) ps

pull:
	$(COMPOSE) pull

mysql:
	$(COMPOSE) exec $(SERVICE) mysql --default-character-set=utf8mb4 -u root -p

version:
	$(COMPOSE) exec $(SERVICE) mysql --version

init:
	$(MYSQL_ROOT) < docker/mysql/init/01_schema.sql
	$(MYSQL_ROOT) $(MYSQL_DATABASE) < docker/mysql/init/02_seed.sql

json:
	$(MYSQL_ROOT) $(MYSQL_DATABASE) < sql/json_examples.sql

clean:
	$(COMPOSE) down -v
