#!/usr/bin/env bash

set -a
set -euox pipefail

TFSTATE_RG='prefect-rg'
TFSTATE_REGION='australiaeast'

az group create \
  --name $TFSTATE_RG \
  --location $TFSTATE_REGION

SA_NAME=tfstate$RANDOM

az storage account create \
  --name $SA_NAME \
  --resource-group $TFSTATE_RG \
  --location $TFSTATE_REGION \
  --sku Standard_RAGRS \
  --kind StorageV2

echo "Successfully created TF State Storage account $SA_NAME"

SA_KEY=$(az storage account keys list -g $TFSTATE_RG -n $SA_NAME | jq ".[0] | .value")

CONTAINER_NAME=terraform

echo "Creating blob container $CONTAINER_NAME"

az storage container create --name $CONTAINER_NAME --account-name $SA_NAME --account-key $SA_KEY
echo "storage_account_name: $SA_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $SA_KEY"