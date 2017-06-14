FROM alpine:3.6

ENV CONSUL_TEMPLATE_VERSION 0.18.5

RUN apk update && \
    apk add ca-certificates wget unzip && \
    update-ca-certificates

RUN wget -O /tmp/consul-template.zip https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \
    unzip /tmp/consul-template.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/consul-template && \
    rm -rf consul-template.zip

WORKDIR /etc/consul-template
ENTRYPOINT ["/usr/local/bin/consul-template"]
