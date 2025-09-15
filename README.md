# Azure Playground

## Init (only once)



```
# prepare: storage_account_name.txt (the name of the bucket, see link below)
# prepare: storage_access_key.txt (a bucket access key, see link below)
# prepare: subscription_id.txt (see My Subscriptions link below)
# prepare: make sure that your IP is whitelisted on the storage account (curl ipconfig.me)

# have az cli installed
brew install azure-cli

# log in once
az login

sh create_tf_client.sh > env.sh
echo "export ARM_ACCESS_KEY=$(cat storage_access_key.txt)" >> env.sh
source env.sh
terraform init -backend-config="storage_account_name=$(cat storage_account_name.txt)"
```

[My Subscriptions](https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBladeV2)

[TF State Bucket](https://portal.azure.com/#@philippbartschprotonmail.onmicrosoft.com/resource/subscriptions/c0be1f03-62e1-4cea-81e4-df888785b929/resourceGroups/terraform-playground/providers/Microsoft.Storage/storageAccounts/terraformstate09876/overview)

## Plan, Apply

The usual.

## Delete the CLI principal

`az ad sp delete --id $(az ad sp list --display-name "TerraformCLI" --query "[].appId" -o tsv)`
