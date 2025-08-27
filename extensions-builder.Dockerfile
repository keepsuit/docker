# syntax=docker/dockerfile:1

ARG PHP_VERSION=8.4
ARG IMAGE_VERSION=v3.6.0
ARG OS_VARIANT=debian
ARG GRPC_VERSION=1.74.0

FROM serversideup/php:${PHP_VERSION}-${OS_VARIANT}-${IMAGE_VERSION} AS build
USER root
ARG GRPC_VERSION
RUN install-php-extensions grpc-${GRPC_VERSION}
RUN mkdir -p /output \
    && cp -r $(php-config --extension-dir)/grpc.so /output

FROM scratch
ARG PHP_VERSION
ARG OS_VARIANT
ARG TARGETARCH
COPY --from=build /output /${PHP_VERSION}/${OS_VARIANT}/${TARGETARCH}/
