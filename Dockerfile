FROM gcr.io/distroless/static
LABEL org.opencontainers.image.source https://github.com/takuyahara/test-docker-secret

ADD .env ./.env

ENTRYPOINT [ "echo", "Hello world!" ]