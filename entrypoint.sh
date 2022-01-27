#!/bin/sh
while :; do 
   certbot certonly -d $DomainName -a dns-azure --dns-azure-credentials /var/azure-dns-cred.json --dns-azure-resource-group $AzureDnsResourceGroup --keep-until-expiring --text --email $ContactEmail --agree-tos -q; nginx -s reload; 
   sleep 24h & wait $!;
done & nginx -g 'daemon off;'
