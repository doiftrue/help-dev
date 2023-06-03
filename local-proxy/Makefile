-include Makefile-extend.mk


dc.up:
	docker-compose up -d

dc.stop:
	docker-compose stop

dc.start:
	docker-compose start

dc.down:
	docker-compose down --remove-orphans

dc.build:
	docker-compose up -d --build

dc.recreate:
	docker-compose up -d --no-deps --build $(filter-out $@,$(MAKECMDGOALS))


goto.nginx:
	docker-compose exec nginx sh
