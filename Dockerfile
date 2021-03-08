FROM nginx:1.19

RUN apt-get update && apt-get install -y \
  python3 python3-pip \
  && rm -rf /var/lib/apt/lists/*

RUN pip install certbot-azure

ENTRYPOINT ["/bin/sh","-c",'while :; do sleep 12h & wait $${!};  certbot certonly -d $DomainName -a dns-azure --dns-azure-credentials /var/azure-dns-cred.json --dns-azure-resource-group $AzureDnsResourceGroup --renew-by-default --text; nginx -s reload; done & nginx -g \"daemon off;\"']
