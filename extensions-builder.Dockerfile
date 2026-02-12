# syntax=docker/dockerfile:1

ARG PHP_VERSION=8.4
ARG OS_VARIANT=debian
ARG GRPC_VERSION=1.78.0

FROM php:${PHP_VERSION}-alpine AS base_alpine
FROM php:${PHP_VERSION}-trixie AS base_debian

FROM base_${OS_VARIANT} AS build
USER root
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
ARG GRPC_VERSION
RUN install-php-extensions grpc-${GRPC_VERSION}
RUN mkdir -p /output \
    && cp -r $(php-config --extension-dir)/grpc.so /output/grpc-${GRPC_VERSION}.so

FROM scratch
ARG PHP_VERSION
ARG OS_VARIANT
ARG TARGETARCH
COPY --from=build /output /${PHP_VERSION}/${OS_VARIANT}/${TARGETARCH}/
