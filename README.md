# Dockerfile for nginx and certbot

Trying to pack [certbot-azure](https://github.com/dlapiduz/certbot-azure) and nginx in a single docker image to deploy to RPI 4b (target linux/arm64).

You will need a `/var/azure-dns-cred.json` file with the following content, as seen in [this page](https://docs.microsoft.com/en-us/azure/developer/github/connect-from-azure):

``` json
{
    "clientId": "<GUID>",
    "clientSecret": "<Password>",
    "subscriptionId": "<GUID>",
    "tenantId": "<GUID>"
}
```

The service principal should have a role assignment than can make changes to the Azure DNS.
