FROM openjdk:21-ea-17-slim-bullseye

ARG EASY_ADD_VERSION=0.7.1
ARG APT_UPDATE=20230414.0
ARG UID=1000
ARG GID=1000
ARG UNAME=bdc
ARG BRC_VERSION
ARG TARGETARCH

# Label docker image
LABEL org.opencontainers.image.authors="Björn Strausmann <bjoern@strausmann.net>"
LABEL org.opencontainers.image.source="https://git.isp-serverfarm.de/minecraft/bedrock-connect"
LABEL org.opencontainers.image.vendor="strausmann"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.documentation="https://git.isp-serverfarm.de/minecraft/bedrock-connect"
LABEL net.strausmann.image.brc.source="https://github.com/Pugmatt/BedrockConnect"
LABEL net.strausmann.image.apt.lastupdate=$APT_UPDATE

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    unzip \
    jq \
    nano \
    procps \
    iputils-ping \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 19132/udp

RUN mkdir -p /docker/brc && mkdir -p /config && chmod 664 /config

VOLUME [ "/data" ]

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/entrypoint-demoter", "--match", "/data", "--debug", "--stdin-on-term", "stop", "/opt/bedrock-entry.sh"]

# Get Easy-Add
ADD https://github.com/itzg/easy-add/releases/download/${EASY_ADD_VERSION}/easy-add_linux_${TARGETARCH} /usr/local/bin/easy-add
RUN chmod +x /usr/local/bin/easy-add

# Get entrypoint-demoter
RUN easy-add --var version=0.4.0 --var app=entrypoint-demoter --file {{.app}} --from https://github.com/itzg/{{.app}}/releases/download/v{{.version}}/{{.app}}_{{.version}}_linux_${TARGETARCH}.tar.gz
# Get MC-Monitor
RUN easy-add --var version=0.10.6 --var app=mc-monitor --file {{.app}} --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_linux_${TARGETARCH}.tar.gz
# Get set-property
RUN easy-add --var version=0.1.1 --var app=set-property --file {{.app}} --from https://github.com/itzg/{{.app}}/releases/download/{{.version}}/{{.app}}_{{.version}}_linux_${TARGETARCH}.tar.gz
# Add Bedrock-Entry
COPY *.sh /opt/

HEALTHCHECK --start-period=1m CMD /usr/local/bin/mc-monitor status-bedrock --host 127.0.0.1 --port 19132
