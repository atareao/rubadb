###############################################################################
## Rustic builder
###############################################################################
FROM rust:alpine3.22 AS rustic-builder
RUN apk add --update --no-cache \
            autoconf \
            gcc \
            gdb \
            git \
            libdrm-dev \
            libepoxy-dev \
            make \
            mesa-dev \
            strace \
            openssl \
            openssl-dev \
            musl-dev && \
    rm -rf /var/cache/apk && \
    rm -rf /var/lib/app/lists

WORKDIR /rustic-builder
RUN cargo install --git https://github.com/rustic-rs/rustic.git rustic-rs
###
FROM alpine:3.21

LABEL maintainer="Lorenzo Carbonell <a.k.a. atareao> lorenzo.carbonell.cerezo@gmail.com"

ENV USER=app \
    UID=1000

RUN apk add --update \
            --no-cache \
            curl~=8.13 \
            mariadb-client~=11.4 \
            postgresql17-client~=17.6 \
            dcron~=4.6 \
    rm -rf /var/cache/apk && \
    rm -rf /var/lib/app/lists*

COPY --from=rustic-builder /usr/local/cargo/bin/rustic /usr/local/bin/rustic
COPY run.sh backup.sh /

# Create the user
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/${USER}" \
    --shell "/sbin/nologin" \
    --uid "${UID}" \
    "${USER}" && \
    mkdir -p /app/backup/db && \
    mkdir -p /app/backup/local && \
    chown -R app:app /app

WORKDIR /app
USER app

CMD ["/bin/sh",  "/run.sh"]
