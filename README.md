# zot-mtls-nginx
Simple docker example to run zot registry with nginx reverse proxy with mtls

### Usage
- Start the docker container using the commands below
```sh
docker build -t my-zot .
docker run --rm -d -p 443:443 --name zot my-zot
docker logs zot -f
```

- Simple test using `curl`. Expect a `404`, not a `401`
```sh
curl --cert client.crt --key client.key --cacert ca.crt https://127.0.0.1 -I
HTTP/1.1 404 Not Found
Server: nginx/1.18.0 (Ubuntu)
...
```

- Push a helm chart using this command
```sh
helm push my-chart-1.0.0.tgz oci://127.0.0.1 --ca-file ca.crt --cert-file client.crt --key-file client.key
```
