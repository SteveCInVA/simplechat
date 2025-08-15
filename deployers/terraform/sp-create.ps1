<#
.SYNOPSIS
This script creates an Azure AD Application (App Registration) with an associated Service Principal,
sets up API scopes, roles, assigns the executing user to a specific role, and generates a client secret.

.DESCRIPTION
- The script first checks if an Azure AD Application with the specified name already exists.
- If the application already exists, the script outputs instructions on how to delete the existing 
  App Registration using its ID, then exits without making any changes.
- If the application does not exist, the script creates the Azure AD Application and the corresponding 
  Service Principal, sets up API scopes and roles, assigns the executing user to a specific role, and generates a client secret.
- The final output includes the necessary configuration details (Client ID, Client Secret, Tenant ID, etc.) 
  in JSON format, which is intended for use as a GitHub secret or similar secure storage.
- The script also assigns the executing user as the Owner of the App Registration.

.PARAMETER AppName
The display name of the Azure AD Application to create or check for existence. 
If not specified, it defaults to "sp-ms-simplechat".

.EXAMPLE
.\sp-create.ps1 -AppName "my-app-registration"

# This command will create an Azure AD Application and Service Principal with the name "my-app-registration".
# If an application with this name already exists, it will provide instructions for deleting the existing application 
# using its ID.

#>

param(
    [string]$AppName = "sp-simplechat"
)

# Check if the Azure AD Application already exists
Write-Host "Checking if Azure AD application $AppName already exists..."
$existingApp = az ad app list --filter "displayName eq '$AppName'" | ConvertFrom-Json

if ($existingApp.Count -gt 0) {
    $existingAppId = $existingApp[0].appId
    $existingObjectId = $existingApp[0].id

    Write-Host "Azure AD application $AppName already exists with AppId: $existingAppId and ObjectId: $existingObjectId."

    Write-Host "To delete the existing app registration, use the following command:"
    Write-Host ""
    Write-Host "az ad app delete --id $existingObjectId"
    Write-Host ""
    Write-Host "Exiting script."
    exit
}

# Create Azure AD Service Principal
Write-Host "Creating Azure AD Service Principal for $AppName..."

$subscriptionId = az account show --query id -o tsv
$sp = az ad sp create-for-rbac --name $AppName --role contributor --scopes /subscriptions/$subscriptionId

$outputJson = @{
    clientSecret = $sp.password
    subscriptionId = $subscriptionId
    tenantId = $sp.tenantId
    clientId = $sp.appId
} | ConvertTo-Json -Compress


# Generate the output JSON
Write-Host "***************************************************************************"
Write-Host "Set the GitHub secret AZURE_CREDENTIALS in your fork of the repo to the following JSON:"
Write-Host "This is not possible to retrieve at a later stage, so please save it now."
Write-Host "The GitHub secret is also not possible to retrieve after you've set it, so take note of it somewhere else as well, if you need to."
Write-Host "***************************************************************************"
Write-Host $outputJson
Write-Host "***************************************************************************"
