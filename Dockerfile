FROM node:19-alpine AS buildjs

RUN apk add --no-cache \
    ca-certificates \
    wget \
    unzip

WORKDIR /

RUN wget https://github.com/buldezir/pocketbase/archive/refs/heads/2238-truncate-collection.zip && \
    unzip 2238-truncate-collection.zip && \
    mv pocketbase-2238-truncate-collection pocketbase && \
    cd pocketbase/ui && \
    npm install && \
    npm run build

FROM golang:1.20-alpine AS buildgo

RUN apk add --no-cache \
    ca-certificates \
    wget \
    unzip

WORKDIR /

COPY --from=buildjs /pocketbase/ui/dist /pocketbase-ui-dist

RUN wget https://github.com/buldezir/pocketbase/archive/refs/heads/2238-truncate-collection.zip && \
    unzip 2238-truncate-collection.zip && \
    mv pocketbase-2238-truncate-collection pocketbase && \
    cd pocketbase && \
    go mod download && \
    rm -rf ui/dist && \
    mv /pocketbase-ui-dist ui/dist && \
    cd examples/base && \
    go build

FROM alpine:latest

RUN apk add --no-cache curl

WORKDIR /pb/

COPY --from=buildgo /pocketbase/examples/base/base /pb/pocketbase

EXPOSE 8090

HEALTHCHECK --interval=15s --timeout=3s --start-period=2s CMD curl -f http://localhost:8090/api/health || exit 1

COPY /pb_migrations /pb/pb_migrations

CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8090"]
