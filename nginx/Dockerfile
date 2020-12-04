FROM nginx:1.19-alpine

WORKDIR /app

RUN rm -rf /etc/nginx/conf.d/*
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d /etc/nginx/conf.d/

COPY default.conf /etc/nginx/sites-enabled/

