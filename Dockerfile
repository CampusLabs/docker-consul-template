FROM quay.io/orgsync/base:1.0.0

ENV VERSION 0.14.0
WORKDIR /consul-template
RUN apt-get update \
  && apt-get install -y unzip netcat-openbsd \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && wget https://releases.hashicorp.com/consul-template/${VERSION}/consul-template_${VERSION}_linux_amd64.zip \
  && unzip consul-template_${VERSION}_linux_amd64.zip \
  && mv consul-template /bin/ \
  && rm -R /consul-template

WORKDIR /
ENTRYPOINT ["/bin/consul-template"]
