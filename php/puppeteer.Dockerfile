ARG IMAGE_TAG=8.4-fpm-debian
FROM keepsuit/php:${IMAGE_TAG}

ARG BUILDPLATFORM
ARG TARGETPLATFORM

USER root

RUN docker-php-serversideup-install-puppeteer
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

USER www-data

# Chromium cannot reliably start under QEMU; retain the smoke test for native builds.
RUN if [ "$BUILDPLATFORM" = "$TARGETPLATFORM" ]; then \
    docker-php-serversideup-test-puppeteer; \
    else \
    echo "Skipping Puppeteer smoke test for cross-platform build: ${BUILDPLATFORM} -> ${TARGETPLATFORM}"; \
    fi
