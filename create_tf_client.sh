#!/bin/bash

# Set your subscription ID (replace with yours; get it via `az account show --query id -o tsv`)
SUBSCRIPTION_ID="$(cat subscription_id.txt)"

# Create service principal with a display name
SP_OUTPUT=$(az ad sp create-for-rbac --name "TerraformCLI" --role Contributor --scopes /subscriptions/$SUBSCRIPTION_ID --query "{appId:appId, password:password, tenant:tenantId}")

# Extract values
CLIENT_ID=$(echo $SP_OUTPUT | jq -r '.appId')
CLIENT_SECRET=$(echo $SP_OUTPUT | jq -r '.password')
TENANT_ID=$(echo $SP_OUTPUT | jq -r '.tenant')

# Output for Terraform env vars
echo "export ARM_SUBSCRIPTION_ID=\"$SUBSCRIPTION_ID\""
echo "export ARM_CLIENT_ID=\"$CLIENT_ID\""
echo "export ARM_CLIENT_SECRET=\"$CLIENT_SECRET\""
echo "export ARM_TENANT_ID=\"$TENANT_ID\""