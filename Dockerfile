# syntax = docker/dockerfile:1.2
FROM nginx:1.19

RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && apt-get install -y \
  python3 python3-pip cython3 libffi-dev rustc libssl-dev \
  && rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache/pip \
  pip3 install --upgrade certbot-azure cryptography

ENTRYPOINT ["/bin/sh","-c","while :; do sleep 12h & wait $!; certbot certonly -d $DomainName -a dns-azure --dns-azure-credentials /var/azure-dns-cred.json --dns-azure-resource-group $AzureDnsResourceGroup --renew-by-default --text --email $ContactEmail --agree-tos -q; nginx -s reload; done & nginx -g 'daemon off;'"]
