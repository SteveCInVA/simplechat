# Configurations required for deployment via Terraform

## Deployment of Shared services:

- Strongly recommend that users create a separate resource group in the target subscription that can be used for "shared" services.  This includes services such Azure Container Registry and OpenAI Service.

## 1. Powershell creation of Service Principal

Execute sp-create.ps1 file and save the result output
By default this script will create a service principal with the name of "sp-simplechat"  If this needs to be changed, override with the use of -AppName flag

```
.\sp-create.ps1 
```
Or 
```
.\sp-create.ps1 -AppName "my-app-registration"
```
The results from this script will look like this:  {"subscriptionId":"`<XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX>`","clientId":"`<11111111-1111-1111-1111-111111111111>`","clientSecret":"`<CLIENT SECRET>`","tenantId":"`<AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA>`"} 

This information must be saved and will be needed in a later step.  DO NOT CHECK THESE SECRETS INTO SOURCE CONTROL.

## 2.  Grant permissions needed for deployment to Service princial

In Entra > Manage > Roles and administrators > All roles > search for "Cloud Application Administrator" 
  Select Add Assignments > Select member(s) "sp-simplechat" or any overriden name as created with the sp-create.ps1

In Entra > Manage > Roles and administrators > All roles > search for "Directory Readers" 

  Select Add Assignments > Select member(s) "sp-simplechat" or any overriden name as created with the sp-create.ps1

In Entra > Manage > Roles and administrators > All roles > search for "Groups Administrator" 

  Select Add Assignments > Select member(s) "sp-simplechat" or any overriden name as created with the sp-create.ps1

In Entra > App registration > Manage > API permissions.  Add Microsoft Graph:  Appliaction.ReadWrite.All, Directory.ReadWrite.All, Group.ReadWrite.All, User.Read
  Ensure Grant admin consent for domain has been set after adding api's.

In target subscription > Access control (IAM) > Add "sp-simplechat" service principal as "User Access Administator"

## Github Configurations:

In your Github Repo for SimpleChat > Settings > Security > Secrets and variables > Actions

### Secrets:
Add the following Repository Secrets:

- AZURE_CREDENTIALS: (This is directly taken from Step 1)
```hcl
{
  "clientSecret": "<your-service-principal-client-secret>",  
  "subscriptionId": "<your-azure-subscription-id>",
  "tenantId": "<your-azure-tenant-id>",
  "clientId": "<your-service-principal-client-id>"
}
```
- ACR_USERNAME: `<Username from Azure Container Registry>`
- ACR_PASSWORD: `<password from Azure Container Registry>`

### Variables:

#### Primary configurations
- GLOBAL_WHICH_AZURE_PLATFORM: 
- PARAM_CREATE_ENTRA_SECURITY_GROUPS:
- PARAM_LOCATION: `<azure deployment region>` **Valid entries can be found using az account list-locations -o table" and referencing the Name column.**
- PARAM_RESOURCE_OWNER_EMAIL_ID:
- PARAM_RESOURCE_OWNER_ID:
- PARAM_TENANT_ID:
- PARAM_SUBSCRIPTION_ID:

#### ACR Variables
- ACR_RESOURCE_GROUP_NAME: 
- ACR_NAME: 
- IMAGE_NAME: 

#### SimpleChat Variables
- PARAM_ENVIRONMENT: 
- PARAM_BASE_NAME: 

#### Open AI Variables
- PARAM_USE_EXISTING_OPENAI_INSTANCE: 
- PARAM_EXISTING_AZURE_OPENAI_RESOURCE_NAME: 
- PARAM_EXISTING_AZURE_OPENAI_RESOURCE_GROUP_NAME: 

#### Terraform State Configurations
- TFSTATE_AZURE_LOCATION: `<azure deployment region>` **Valid entries can be found using az account list-locations -o table" and referencing the Name column.**
- TFSTATE_RESOURCE_GROUP_NAME: `<resource group name that will persist the terraform state files>` **This should be outside of the deployment resource group.**
- TFSTATE_STORAGE_ACCOUNT_NAME: `<storage account name for terraform state files>`  **Needs to have no spaces or special characters**
- TFSTATE_STORAGE_CONTAINER: `<environment for deployment state>`

