COMPOSE := docker compose
SERVICE := mysql

.DEFAULT_GOAL := help

.PHONY: help up down restart logs ps pull mysql version clean

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
	$(COMPOSE) exec $(SERVICE) mysql -u root -p

version:
	$(COMPOSE) exec $(SERVICE) mysql --version

clean:
	$(COMPOSE) down -v
