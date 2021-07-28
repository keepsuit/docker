DOCKER_CLI_EXPERIMENTAL=enabled

.PHONY: php8.0 nginx laravel-app

php8.0:
	docker buildx build --push --file php8.0/Dockerfile -t keepsuit/php:8.0 -t keepsuit/php:latest ./php8.0

nginx:
	docker buildx build --push --file nginx/Dockerfile -t keepsuit/nginx-php-proxy:latest ./nginx

laravel-app:
	docker buildx build --push --file laravel-app/php80.Dockerfile -t keepsuit/laravel-app:latest -t keepsuit/laravel-app:8.0 ./laravel-app