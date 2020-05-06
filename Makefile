# Set environment variables
export RESOURCE_GROUP?=jitsi
export LOCATION?=westeurope
export TIMESTAMP=`date "+%Y-%m-%d-%H-%M-%S"`
export SHELL=/bin/bash
export SSH_KEY?=$(HOME)/.ssh/id_rsa.pub
export OWN_KEY:=True
export ADMIN_USERNAME?=$(USER)
export JITSI_ADMIN_USERNAME?=$(USER)
export JITSI_ADMIN_PASSWORD?=dont_forget_to_redefine_me_in_.env
export LETSENCRYPT_DOMAIN?=meet.yourdomain
export LETSENCRYPT_EMAIL?=you@yourdomain

# Permanent local overrides
-include .env

# dump resource groups
resources:
	az group list --output table

# Dump list of location IDs
locations:
	az account list-locations --output table

sizes:
	az vm list-sizes --location=$(LOCATION) --output table

# Generate the Azure Resource Template parameter files
params:
	@mkdir parameters 2> /dev/null; python genparams.py > parameters/server.json

# Cleanup parameters
clean:
	rm -rf parameters

# Create a resource group and deploy the cluster resources inside it
deploy:
	-az group create --name $(RESOURCE_GROUP) --location $(LOCATION) --output table 
	az deployment group create \
		--template-file templates/server.json \
		--parameters @parameters/server.json \
		--resource-group $(RESOURCE_GROUP) \
		--name cli-$(LOCATION) \
		--output table \
		--no-wait

redeploy:
	-make destroy
	while [[ $$(az group list | grep Deleting) =~ "Deleting" ]]; do sleep 30; done
	make params
	make deploy

# Destroy the entire resource group and all cluster resources
destroy:
	az group delete \
		--name $(RESOURCE_GROUP) \
		--no-wait

# View deployment details
view-deployment:
	az group deployment operation list \
		--resource-group $(RESOURCE_GROUP) \
		--name cli-$(LOCATION) \
		--query "[].{OperationID:operationId,Name:properties.targetResource.resourceName,Type:properties.targetResource.resourceType,State:properties.provisioningState,Status:properties.statusCode}" \
		--output table

# List endpoints
list-endpoints:
	az network public-ip list \
		--resource-group $(RESOURCE_GROUP) \
		--query '[].{dnsSettings:dnsSettings.fqdn}' \
		--output table
