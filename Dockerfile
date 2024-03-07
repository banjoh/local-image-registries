FROM registry:2

COPY config.yaml /etc/docker/registry/config.yml
COPY test-htpasswd /etc/registry/htpasswd
# COPY certs/ /etc/docker/registry/certs
