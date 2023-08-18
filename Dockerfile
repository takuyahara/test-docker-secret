FROM alpine:latest
LABEL org.opencontainers.image.source https://github.com/takuyahara/test-docker-secret

ADD .env ./.env
RUN rm ./.env