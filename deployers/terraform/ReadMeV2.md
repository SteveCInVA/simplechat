In GitHub configure the following

Secrets:
- AZURE_CREDENTIALS: 
```hcl
{
  "clientSecret": "<your-service-principal-client-secret>",  
  "subscriptionId": "<your-azure-subscription-id>",
  "tenantId": "<your-azure-tenant-id>",
  "clientId": "<your-service-principal-client-id>"
}
```

Variables:
TFSTATE_AZURE_LOCATION: northcentralus
TFSTATE_RESOURCE_GROUP_NAME: stecarrsimplechat-shared-rg
TFSTATE_STORAGE_ACCOUNT_NAME: stecarrsimplechatstate01
TFSTATE_STORAGE_CONTAINER: dev01