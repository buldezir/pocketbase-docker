FROM alpine:latest

ARG PB_VERSION
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache \
    unzip \
    ca-certificates \
    curl

# download and unzip PocketBase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_${TARGETOS}_${TARGETARCH}.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/

WORKDIR /pb/

EXPOSE 8090

HEALTHCHECK --interval=20s --timeout=3s --start-period=2s CMD curl -f http://localhost:8090/api/health || exit 1

COPY /pb_migrations /pb/pb_migrations

CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8090"]
