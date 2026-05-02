#!/bin/sh
set -eu

: "${DomainName:?DomainName is required}"
: "${ContactEmail:?ContactEmail is required}"
: "${AzureDnsResourceGroup:?AzureDnsResourceGroup is required}"
: "${AzureDnsCredentials:=/var/azure-dns-cred.json}"

if [ ! -f "$AzureDnsCredentials" ]; then
  echo "Azure DNS credentials file not found: $AzureDnsCredentials" >&2
  exit 1
fi

CERTBOT_CMD="/opt/certbot/bin/python3 -m certbot"
if [ ! -x "/opt/certbot/bin/python3" ]; then
  echo "certbot virtualenv python not found at /opt/certbot/bin/python3" >&2
  exit 1
fi

echo "Starting certbot with: $(/opt/certbot/bin/python3 -m certbot --version)"
echo "Installed certbot plugins:"
/opt/certbot/bin/python3 -m certbot plugins | sed -n '1,20p'

if ! $CERTBOT_CMD plugins | grep -q '^dns-azure'; then
  echo "Warning: certbot dns-azure plugin not found" >&2
  $CERTBOT_CMD plugins
fi

while true; do
  $CERTBOT_CMD certonly -d "$DomainName" -a dns-azure \
    --dns-azure-credentials "$AzureDnsCredentials" \
    --dns-azure-resource-group "$AzureDnsResourceGroup" \
    --keep-until-expiring --text --email "$ContactEmail" \
    --agree-tos -q
  nginx -s reload
  sleep 24h
done & exec nginx -g 'daemon off;'
