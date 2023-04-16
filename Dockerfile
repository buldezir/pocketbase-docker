FROM golang:1.20-alpine AS build

RUN apk add --no-cache \
    git \
    ca-certificates \
    curl

WORKDIR /pb/

RUN git clone https://github.com/buldezir/pocketbase.git && \
    cd pocketbase && \
    git checkout 2238-truncate-collection && \
    go mod download && \
    cd examples/base && \
    go build

FROM alpine:latest

WORKDIR /pb/

COPY --from=build /pb/pocketbase/examples/base/base /pb/pocketbase

EXPOSE 8090

HEALTHCHECK --interval=20s --timeout=3s --start-period=2s CMD curl -f http://localhost:8090/api/health || exit 1

COPY /pb_migrations /pb/pb_migrations

CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8090"]
