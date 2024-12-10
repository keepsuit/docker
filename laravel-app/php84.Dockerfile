# syntax=docker/dockerfile:1

FROM keepsuit/php:8.4-fpm
ARG TARGETARCH

RUN docker-php-serversideup-dep-install-alpine "tzdata ca-certificates"

ENV SUPERCRONIC_VERSION=v0.2.33
RUN curl -sSL -o supercronic "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-${TARGETARCH}" \
    && chmod +x supercronic \
    && mv supercronic /usr/local/bin/supercronic
RUN mkdir -p /etc/supercronic \
    && echo '* * * * * cd /app && php artisan schedule:run' > /etc/supercronic/crontab

ENV GRPC_HEALTH_PROBE_VERSION=v0.4.35
RUN curl -sSL -o grpc_health_probe "https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-${TARGETARCH}" \
    && chmod +x grpc_health_probe \
    && mv grpc_health_probe /usr/local/bin/grpc_health_probe
