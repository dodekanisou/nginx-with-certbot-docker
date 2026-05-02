# Dockerfile for nginx and certbot

Trying to pack a forked version of [certbot-azure](https://github.com/dodekanisou/certbot-azure) and nginx in a single docker image to deploy to RPI 4b (target linux/arm64). Docker images available in [docker hub](https://hub.docker.com/r/dodekanisou/nginx-with-certbot).

## Environment Variables

The container requires the following environment variables to be set:

- `DomainName` (required): Domain(s) for which to obtain certificates. Multiple domains can be specified using semicolons (`;`) or spaces as separators. Example: `example.com;www.example.com` or `example.com www.example.com`
- `ContactEmail` (required): Email address for Let's Encrypt account and renewal notifications
- `AzureDnsResourceGroup` (required): Name of the Azure resource group containing the DNS zone
- `AzureDnsCredentials` (optional): Path to the Azure credentials file. Defaults to `/var/azure-dns-cred.json`

## Azure DNS Credentials

You will need a `/var/azure-dns-cred.json` file with the following content, as seen in [this page](https://docs.microsoft.com/en-us/azure/developer/github/connect-from-azure):

``` json
{
    "clientId": "<GUID>",
    "clientSecret": "<Password>",
    "subscriptionId": "<GUID>",
    "tenantId": "<GUID>",
    "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
    "resourceManagerEndpointUrl": "https://management.azure.com/",
    "activeDirectoryGraphResourceId": "https://graph.windows.net/",
    "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
    "galleryEndpointUrl": "https://gallery.azure.com/",
    "managementEndpointUrl": "https://management.core.windows.net/"
}
```

The service principal should have a role assignment than can make changes to the Azure DNS.
