SHELL := bash

include .env
export

run:
	docker-compose -p ${PROJECT_NAME} -f docker-compose.yml up -d

stop:
	docker-compose -p ${PROJECT_NAME} -f docker-compose.yml down

clean:
	docker-compose -p ${PROJECT_NAME} -f docker-compose.yml rm --stop --force

dump-db:
	docker exec $(DB_CONTAINER_NAME) mysqldump -u $(DB_USER) -p$(DB_PASSWORD) $(DB_NAME) > docker-entrypoint-initdb.d/dump.sql

restore-db:
	docker exec -i $(DB_CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASSWORD) $(DB_NAME) < docker-entrypoint-initdb.d/dump.sql

dump-wp-content:
	docker cp $(WP_CONTAINER_NAME):/var/www/html/wp-content ./

restore-wp-content:
	docker cp ./wp-content $(WP_CONTAINER_NAME):/var/www/html
	docker exec $(WP_CONTAINER_NAME) chown -R www-data:www-data /var/www/html/wp-content
