#!/bin/sh
while :; do 
   certbot certonly -d $DomainName -a dns-azure --dns-azure-credentials /var/azure-dns-cred.json --dns-azure-resource-group $AzureDnsResourceGroup --renew-by-default --text --email $ContactEmail --agree-tos -q; nginx -s reload; 
   sleep 12h & wait $!;
done & nginx -g 'daemon off;'
