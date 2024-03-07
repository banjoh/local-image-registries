#!/bin/env bash

mkdir -p certs

CONFIG="
[req]
distinguished_name=dn
[ dn ]
[ ext ]
basicConstraints=CA:TRUE,pathlen:0
nsCertType = client, server
nsComment = "Local Test Client Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
"
DAYS=3650
pushd certs

rm -f server* client.* ca.*

openssl genrsa -out ca.key 2048
openssl req -config <(echo "$CONFIG") -new -x509 -days $DAYS -key ca.key -subj "/CN=Root CA" -out ca.crt
openssl req -newkey rsa:2048 -nodes -keyout server.key -subj "/CN=server" -out server.csr
openssl req -newkey rsa:2048 -nodes -keyout client.key -subj "/CN=client" -out client.csr
# openssl x509 -req -extfile <(printf "subjectAltName=DNS:example.com") -days $DAYS -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
openssl x509 -req -extfile <(printf "subjectAltName=DNS:example.com,DNS:localhost,IP:127.0.0.1") -days $DAYS -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
chmod 600 server.key
cat server.crt ca.crt > server-fullchain.crt
openssl req -newkey rsa:2048 -nodes -keyout client.key -subj "/CN=client" -out client.csr
openssl x509 -req -days $DAYS -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt

popd
