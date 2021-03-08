#!/bin/sh
while :; do 
   sleep 12h & wait $!;
   certbot certonly -d $DomainName -a dns-azure --dns-azure-credentials /var/azure-dns-cred.json --dns-azure-resource-group $AzureDnsResourceGroup --renew-by-default --text --email $ContactEmail --agree-tos -q; nginx -s reload; 
done & nginx -g 'daemon off;'