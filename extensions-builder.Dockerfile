# syntax=docker/dockerfile:1

ARG PHP_VERSION=8.3
ARG VARIANT=bookworm
ARG GRPC_VERSION=1.70.0

FROM serversideup/php:${PHP_VERSION}-${VARIANT} AS build
USER root
ARG GRPC_VERSION
RUN install-php-extensions grpc-${GRPC_VERSION}
RUN mkdir -p /output \
    && cp -r $(php-config --extension-dir)/grpc.so /output

FROM scratch
ARG PHP_VERSION
ARG VARIANT
ARG TARGETARCH
COPY --from=build /output /${PHP_VERSION}/${VARIANT}/${TARGETARCH}/
