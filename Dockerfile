# Source: https://github.com/project-zot/zot/blob/main/build/Dockerfile
FROM ubuntu

ARG TARGETOS
ARG TARGETARCH

WORKDIR /workdir

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install curl nginx-extras -y && \
    curl -L https://github.com/project-zot/zot/releases/latest/download/zot-$TARGETOS-$TARGETARCH -o /usr/bin/zot
RUN echo '{\n\
    "storage": {\n\
        "rootDirectory": "/var/lib/registry"\n\
    },\n\
    "http": {\n\
        "address": "127.0.0.1",\n\
        "port": "5000"\n\
    },\n\
    "log": {\n\
        "level": "debug"\n\
    }\n\
}\n' > config.json && cat config.json

COPY start.sh start.sh
COPY ca.crt /etc/nginx/client_certs/ca.crt
COPY server-fullchain.crt /etc/nginx/server.crt
COPY server.key /etc/nginx/
COPY nginx.conf /etc/nginx/nginx.conf
RUN chmod +x start.sh && chmod +x /usr/bin/zot

EXPOSE 443
VOLUME ["/var/lib/registry"]
CMD ["/workdir/start.sh"]
