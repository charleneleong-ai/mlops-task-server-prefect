# AKS Cluster 


## Step 1: Configure Azure for Deployment

The steps below will walk you through how to:

- Create an Azure Resource Group
- Create an AKS Cluster
- Authenticate with your AKS Cluster

You can view Microsoft Azure's Web Portal at https://portal.azure.com/.

### 1.1  Create Resource Group

```zsh
❯ az login
❯ az account set --subscription <subscription_id>
❯ az account show
```

Run `❯ az account list-locations` to see all locations.

### 1.1  Enable cluster monitoring

Enable cluster monitoring

1. Verify Microsoft.OperationsManagement and Microsoft.OperationalInsights are registered on your subscription. To check the registration status:
  
```zsh

az provider show -n Microsoft.OperationsManagement -o table
az provider show -n Microsoft.OperationalInsights -o table
```


If they are not registered, register Microsoft.OperationsManagement and Microsoft.OperationalInsights using:

```zsh
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.OperationalInsights
```


### 1.2  Create Service Principal

```zsh
❯ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
```
Output:

```zsh
{
  "appId": "00000000-0000-0000-0000-000000000000",
  "displayName": "azure-cli-2017-06-05-10-41-15",
  "name": "http://azure-cli-2017-06-05-10-41-15",
  "password": "0000-0000-0000-0000-000000000000",
  "tenant": "00000000-0000-0000-0000-000000000000"
}
```
Create `azurecreds.conf` and `azurecreds.env` file with these vars.

`azurecreds.conf`
```zsh
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="0000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

`azurecreds.env`
```zsh
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="0000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

Login

```zsh
❯ source azurecreds.env
❯ az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
```

### 1.3  Create AKS cluster

Enable Azure Monitor for containers using the --enable-addons monitoring parameter.

Through CLI

```zsh
❯ az aks create --name <cluster_name> --resource-group <resource_group_name> --node-vm-size --node-vm-size Standard_D8s_v3 --node-count 3 --enable-addons monitoring

❯ az aks get-credentials --resource-group <resource_group_name> --name <cluster_name>

```

If you'd like to deploy via Terraform - 

Creating remote TF backend via CLI

```zsh
❯ cd terraform 
❯ ./deploy_tfstate_backend.sh    
```

[Optional] Creating remote TF backend via Terraform

```zsh
❯ cd terraform/backends 
❯ terraform init -backend-config=azurecreds.conf
❯ terraform apply -auto-approve
```


### 1.4 Deploy AKS Cluster via Terraform

Take note of the backend vars and configure in [`tfvars/backend.tfvars`](./terraform/tfvars/backend.tfvars).

```zsh
# ❯ cd terraform/backends 
❯ terraform init -backend-config=tfvars/backend.tfvars
❯ terraform plan -out out.plan -var-file=tfvars/test.tfvars
❯ terraform apply "out.plan"
```


### 1.5 Test the K8s Cluster

Export config and see nodes.

```zsh
❯ echo "$(terraform output kube_config | sed -e 's/EOT//g' -e  's/<<//g')" > ../manifests/aks.yaml
❯ export KUBECONFIG=./manifests/aks.yaml
❯ kubectl get nodes
```

### 1.6 Auth into new cluster

```zsh
❯ az aks get-credentials --resource-group <rg_name> --name k8stest
```

## Tools

To experiment with queries interactively

```
❯ poetry add jmespath-terminal --dev
❯ az ad sp list --display-name spcertmanageridentity | jpterm
```