# consul-template [![Docker Repository on Quay](https://quay.io/repository/orgsync/consul-template/status "Docker Repository on Quay")](https://quay.io/repository/orgsync/consul-template)
HashiCorp's consul template with netcat-openbsd for signaling containers


Setup consul template in `docker-compose.yml` to write the template mounted in
`/etc/consul-template/nginx.conf.ctmpl` to `/tmp/nginx/nginx.conf` and execute
the `restart-nginx` script whenever the containers change:

```yml
consultemplate:
  image: quay.io/orgsync/consul-template:0.14.0
  working_dir: /etc/consul-template
  command: >
    -consul 172.17.0.1:8500
    -template "nginx.conf.ctmpl:/tmp/nginx/nginx.conf:./restart-nginx"
  volumes:
    - ./docker/config/consul-template:/etc/consul-template
    - /var/run/docker.sock:/tmp/docker.sock
    - /tmp/nginx:/tmp/nginx
  links:
    - consul

nginx:
  image: nginx
  ports:
    - "80:80"
  volumes:
    - /tmp/nginx/nginx.conf:/etc/nginx/nginx.conf:ro
```

In `restart-nginx`, send a `HUP` signal to nginx:

```bash
#!/bin/bash -e

NAME=nginx
SIGNAL=HUP
COMMAND="POST /containers/${NAME}/kill?signal=${SIGNAL} HTTP/1.0\n"
echo $COMMAND | nc -U /tmp/docker.sock
```
