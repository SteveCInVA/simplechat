#!/bin/bash

#set variables
LOCATION="${TFSTATE_AZURE_LOCATION:-northcentralus}"
RESOURCE_GROUP="${TFSTATE_RESOURCE_GROUP_NAME:-stecarrsimplechat-shared-rg}"
STORAGE_ACCOUNT="${TFSTATE_STORAGE_ACCOUNT_NAME:-stecarrsimplechatstate01}"
CONTAINER_NAME="${TFSTATE_STORAGE_CONTAINER:-tfstate}"
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
