.PHONY: extensions
extensions: extensions/8.3 extensions/8.4

.PHONY: extensions/8.3
extensions/8.3: extensions/8.3/amd64 extensions/8.3/arm64

.PHONY: extensions/8.3/amd64
extensions/8.3/amd64:
	docker buildx build --platform=linux/amd64 --build-arg PHP_VERSION=8.3 -f extensions-builder.Dockerfile -o=./assets/extensions/ .
	docker buildx build --platform=linux/amd64 --build-arg PHP_VERSION=8.3 --build-arg VARIANT=alpine -f extensions-builder.Dockerfile -o=./assets/extensions/ .

.PHONY: extensions/8.3/arm64
extensions/8.3/arm64:
	docker buildx build --platform=linux/arm64 --build-arg PHP_VERSION=8.3 -f extensions-builder.Dockerfile -o=./assets/extensions/ .
	docker buildx build --platform=linux/arm64 --build-arg PHP_VERSION=8.3 --build-arg VARIANT=alpine -f extensions-builder.Dockerfile -o=./assets/extensions/ .

.PHONY: extensions/8.4
extensions/8.4: extensions/8.4/amd64 extensions/8.4/arm64

.PHONY: extensions/8.4/amd64
extensions/8.4/amd64:
	docker buildx build --platform=linux/amd64 --build-arg PHP_VERSION=8.4 -f extensions-builder.Dockerfile -o=./assets/extensions/ .
	docker buildx build --platform=linux/amd64 --build-arg PHP_VERSION=8.4 --build-arg VARIANT=alpine -f extensions-builder.Dockerfile -o=./assets/extensions/ .

.PHONY: extensions/8.4/arm64
extensions/8.4/arm64:
	docker buildx build --platform=linux/arm64 --build-arg PHP_VERSION=8.4 -f extensions-builder.Dockerfile -o=./assets/extensions/ .
	docker buildx build --platform=linux/arm64 --build-arg PHP_VERSION=8.4 --build-arg VARIANT=alpine -f extensions-builder.Dockerfile -o=./assets/extensions/ .


# Nome del bucket su S3 e la directory locale
RCLONE_REMOTE ?= s3
S3_BUCKET = $(RCLONE_REMOTE):docker-php-assets.keepsuit.com
LOCAL_DIR = ./assets

# Comandi di default per rclone
RCLONE_CMD = rclone
SYNC_FLAGS = --verbose --progress

# Scarica tutti i file dal bucket S3 alla cartella locale
.PHONY: assets/download
assets/download:
	$(RCLONE_CMD) copy $(SYNC_FLAGS) $(S3_BUCKET) $(LOCAL_DIR)

# Carica tutti i file dalla cartella locale al bucket S3
.PHONY: assets/upload
assets/upload:
	$(RCLONE_CMD) copy $(SYNC_FLAGS) --s3-acl public-read --metadata --metadata-set cache-control="max-age=31536000" $(LOCAL_DIR) $(S3_BUCKET)

# Elimina i file locali che non sono presenti nel bucket S3 e carica i file che non sono presenti nella cartella locale
.PHONY: assets/clear-local
assets/clear-local:
	$(RCLONE_CMD) sync $(SYNC_FLAGS) $(S3_BUCKET) $(LOCAL_DIR)

# Elimina i file nel bucket S3 che non sono presenti nella cartella locale e carica i file che non sono presenti nel bucket S3
.PHONY: assets/clear-remote
assets/clear-remote:
	$(RCLONE_CMD) sync $(SYNC_FLAGS) $(LOCAL_DIR) $(S3_BUCKET)

