# Dockerfile for nginx and certbot

Trying to pack a forked version of [certbot-azure](https://github.com/dodekanisou/certbot-azure) and nginx in a single docker image to deploy to RPI 4b (target linux/arm64). Docker images available in [docker hub](https://hub.docker.com/r/dodekanisou/nginx-with-certbot/tags).

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
