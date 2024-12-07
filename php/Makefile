.PHONY: extensions
extensions: extensions/8.3 extensions/8.4

.PHONY: extensions/8.3
extensions/8.3: extensions/8.3/amd64 extensions/8.3/arm64

.PHONY: extensions/8.3/amd64
extensions/8.3/amd64:
	docker buildx build --platform=linux/amd64 --build-arg PHP_VERSION=8.3 -f extensions-builder.Dockerfile -o=./extensions/ .
	docker buildx build --platform=linux/amd64 --build-arg PHP_VERSION=8.3 --build-arg VARIANT=alpine -f extensions-builder.Dockerfile -o=./extensions/ .

.PHONY: extensions/8.3/arm64
extensions/8.3/arm64:
	docker buildx build --platform=linux/arm64 --build-arg PHP_VERSION=8.3 -f extensions-builder.Dockerfile -o=./extensions/ .
	docker buildx build --platform=linux/arm64 --build-arg PHP_VERSION=8.3 --build-arg VARIANT=alpine -f extensions-builder.Dockerfile -o=./extensions/ .

.PHONY: extensions/8.4
extensions/8.4: extensions/8.4/amd64 extensions/8.4/arm64

.PHONY: extensions/8.4/amd64
extensions/8.4/amd64:
	docker buildx build --platform=linux/amd64 --build-arg PHP_VERSION=8.4 -f extensions-builder.Dockerfile -o=./extensions/ .
	docker buildx build --platform=linux/amd64 --build-arg PHP_VERSION=8.4 --build-arg VARIANT=alpine -f extensions-builder.Dockerfile -o=./extensions/ .

.PHONY: extensions/8.4/arm64
extensions/8.4/arm64:
	docker buildx build --platform=linux/arm64 --build-arg PHP_VERSION=8.4 -f extensions-builder.Dockerfile -o=./extensions/ .
	docker buildx build --platform=linux/arm64 --build-arg PHP_VERSION=8.4 --build-arg VARIANT=alpine -f extensions-builder.Dockerfile -o=./extensions/ .
