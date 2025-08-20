#!/bin/bash

#set variables
LOCATION="${TFSTATE_AZURE_LOCATION:-northcentralus}"
RESOURCE_GROUP="${TFSTATE_RESOURCE_GROUP_NAME:-stecarrsimplechat-shared-rg}"
STORAGE_ACCOUNT="${TFSTATE_STORAGE_ACCOUNT_NAME:-stecarrsimplechatstate01}"
CONTAINER_NAME="${TFSTATE_STORAGE_CONTAINER:-local}"
STATE_FILE="simplechat.terraform.tfstate"

# Create the resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create the storage account
az storage account create \
    --name $STORAGE_ACCOUNT \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --sku Standard_LRS \
    --encryption-services blob

# Get the storage account key
ACCOUNT_KEY=$(az storage account keys list \
    --resource-group $RESOURCE_GROUP \
    --account-name $STORAGE_ACCOUNT \
    --query '[0].value' -o tsv)

# Create the blob container
az storage container create \
    --name $CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT \
    --account-key $ACCOUNT_KEY

# Assign 'Storage Blob Data Contributor' role to the calling user
echo "#############################"
USER_OBJECT_ID=$(az ad sp show --id "$AZURE_CLIENT_ID" --query id -o tsv)
echo "USER_OBJECT_ID: $USER_OBJECT_ID"
if [ -z "$USER_OBJECT_ID" ] ; then
    echo "User object ID not found. Trying service principal lookup..."
    USER_OBJECT_ID=$(az ad signed-in-user show --query id -o tsv)
fi
echo "#############################"

az role assignment create \
    --assignee $USER_OBJECT_ID \
    --role "Storage Blob Data Contributor" \
    --scope "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT"

# Output backend config
cat <<EOF > deployers/terraform/backend.config
    resource_group_name  = "$RESOURCE_GROUP"
    storage_account_name = "$STORAGE_ACCOUNT"
    container_name       = "$CONTAINER_NAME"
    key                  = "$STATE_FILE"
EOF

echo "Configured Terraform backend storage as:"
echo "  Location: $LOCATION"
echo "  Resource Group: $RESOURCE_GROUP"
echo "  Storage Account: $STORAGE_ACCOUNT"
echo "  Container Name: $CONTAINER_NAME"
echo "  State File: $STATE_FILE"
echo "Backend config written to deployers/terraform/backend.config"
