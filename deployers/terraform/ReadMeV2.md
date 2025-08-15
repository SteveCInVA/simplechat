In GitHub configure the following

Secrets:
- AZURE_CREDENTIALS: 
```hcl
{
  "clientId": "<your-service-principal-client-id>",
  "clientSecret": "<your-service-principal-client-secret>",
  "subscriptionId": "<your-azure-subscription-id>",
  "tenantId": "<your-azure-tenant-id>"
}
```