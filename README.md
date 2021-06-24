# Readme

### Prerequisites

* tfenv : https://github.com/tfutils/tfenv 
* jq : https://stedolan.github.io/jq/
* awscli: https://aws.amazon.com/cli/
* aws-vault : https://github.com/99designs/aws-vault

## Set up

Each env has its own main.tf with the minimal required terraform version and minal required terraform providers (keycloak and aws)

More info: about the keycloak provider:  
 * https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs
 * https://github.com/mrparkers/terraform-provider-keycloak/


The correct AWS env variables are needed to fetch passwords and secret from aws secretsmanager
In the examples below AWS-vault is used to easily switch between AWS accounts.
https://github.com/99designs/aws-vault

## managing existing environment:
Use the run scripts to apply the configs to the specified environments:

```
./run-local.sh
```

```
aws-vault exec iam-devel -- ./run-devel.sh
```

```
aws-vault exec iam-uat -- ./run-uat.sh
```

Underlying the run scripts will with "terraform" user on the admin-cli client:
* 'terraform init'
* 'terraform plan'
* 'terraform apply' if answered 'y'

## Starting from scratch (Import)
For the "devel", "uat" and "prod" environments, the master terraform state already exists and is saved and used from within a specified s3 bucket.
Please do not use this import script on those environments

When intialising a complete new environment, it is good idea to import the master realm in terraform before starting with planning and applying terraform configuration.
you can execute following commands ```terraform init``` and ```terraform import``` within your environment directory.

example for master realm: 

```
terraform init
terraform import \
    -var="project=${PROJECT}" \
    -var="subproject=${SUBPROJECT}" \
    -var="env=${ENV}" \
    -var="keycloak_url=${KEYCLOAK_URL}" \
    -var="keycloak_client_id=${KEYCLOAK_CLIENT_ID}" \
    -var="keycloak_user=${KEYCLOAK_USER}" \
    -var="keycloak_password=${KEYCLOAK_PASSWORD}"
    keycloak_realm.master master
```
There is a terraform-import-master.sh script that does the above steps with a aws-vault context. Only use when you know what you are doing. Run from the env folder
example devel
```
cd devel
aws-vault exec iam-devel -- ../scripts/terraform-import-master.sh devel https://iam.devel.unifiedpost.com admin
```
It might be needed to do a refresh of the terraform state.
```
cd devel
aws-vault exec iam-devel -- terraform refresh
```

after importing you can call ./run-my-env.sh and changes defined in ./'env'/realm-master.tf will be applied on the master realm of the 'my-env' environment.

## using local env

Find more info in README.md in the ./local/ directory.