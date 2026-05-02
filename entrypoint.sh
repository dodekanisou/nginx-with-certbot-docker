#!/bin/sh
set -eu

: "${DomainName:?DomainName environment variable is required}"
: "${ContactEmail:?ContactEmail environment variable is required}"
: "${AzureDnsResourceGroup:?AzureDnsResourceGroup environment variable is required}"
: "${AzureDnsCredentials:=/var/azure-dns-cred.json}"

if [ ! -f "$AzureDnsCredentials" ]; then
  echo "Azure DNS credentials file not found: $AzureDnsCredentials" >&2
  exit 1
fi

CERTBOT_CMD="/opt/certbot/bin/certbot"
if [ ! -x "$CERTBOT_CMD" ]; then
  if [ ! -x "/opt/certbot/bin/python3" ]; then
    echo "certbot virtualenv python not found at /opt/certbot/bin/python3" >&2
    exit 1
  fi
  CERTBOT_CMD="/opt/certbot/bin/python3 -m certbot"
fi

echo "Starting certbot with: $($CERTBOT_CMD --version)"
echo "Installed certbot plugins:"
$CERTBOT_CMD plugins | sed -n 's/^\* //p' | sed -n '1,20p'

if ! $CERTBOT_CMD plugins | grep -q '^\* dns-azure'; then
  echo "Warning: certbot dns-azure plugin not found" >&2
  $CERTBOT_CMD plugins
fi

DOMAIN_ARGS=""
for domain in $(printf '%s\n' "$DomainName" | tr ';' ' '); do
  DOMAIN_ARGS="$DOMAIN_ARGS -d $domain"
done

echo "Requesting certificate for:$DOMAIN_ARGS"

while true; do
  $CERTBOT_CMD certonly $DOMAIN_ARGS -a dns-azure \
    --dns-azure-credentials "$AzureDnsCredentials" \
    --dns-azure-resource-group "$AzureDnsResourceGroup" \
    --keep-until-expiring --text --email "$ContactEmail" \
    --agree-tos -q
  nginx -s reload
  sleep 24h
done & exec nginx -g 'daemon off;'
