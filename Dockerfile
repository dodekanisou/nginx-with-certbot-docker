FROM nginx:1.19

RUN apt-get update && apt-get install -y \
  python-pip python-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev dialog \
  && rm -rf /var/lib/apt/lists/*

RUN pip install certbot-azure

ENTRYPOINT ["/bin/sh","-c",'while :; do sleep 12h & wait $${!};  certbot certonly -d $DomainName -a dns-azure --dns-azure-credentials /var/azure-dns-cred.json --dns-azure-resource-group $AzureDnsResourceGroup --renew-by-default --text; nginx -s reload; done & nginx -g \"daemon off;\"']
