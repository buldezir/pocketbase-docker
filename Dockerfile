FROM alpine:latest

ARG PB_VERSION=0.13.2
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

EXPOSE 8090

HEALTHCHECK --interval=20s --timeout=3s --start-period=2s CMD curl -f http://localhost:8090/api/health || exit 1

COPY /pb_migrations /pb/pb_migrations
# COPY /1675281304_create_admin.js /pb/1675281304_create_admin.js
# COPY /entrypoint.sh /pb/entrypoint.sh
# ENTRYPOINT ["/pb/entrypoint.sh"]
CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8090"]
