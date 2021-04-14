#!/bin/bash
# Bootstraps infrastructure and deploys self-contained setup
echo ">>>>> PREPARING LOCAL CONFIGURATION FOR  SINGLE-NODE ASYNC-API-PLATFORM"

LOCAL_ANSIBLE_VARS=vars/sensitive_ansible_vars.yml
if [[ -f "$LOCAL_ANSIBLE_VARS" ]]; then
   echo "$LOCAL_ANSIBLE_VARS already exists." 
else
  cp vars/template_sensitive_ansible_vars.yml vars/sensitive_ansible_vars.yml
  echo "$LOCAL_ANSIBLE_VARS created based on template." 
  echo "Please adjust content of this file before deploying infrastructure."
fi

LOCAL_TERRAFORM_VARS=vars/terraform.tfvars.json
if [[ -f "$LOCAL_TERRAFORM_VARS" ]]; then
   echo "$LOCAL_TERRAFORM_VARS already exists." 
else
  cp vars/template_terraform.tfvars.json vars/terraform.tfvars.json
  echo "$LOCAL_TERRAFORM_VARS created based on template." 
  echo "Please adjust content of this file before deploying infrastructure."
fi

LINK_TERRAFORM_VARS=terraform/terraform.tfvars.json
if [[ -f "$LINK_TERRAFORM_VARS" ]]; then
   echo "Link $LINK_TERRAFORM_VARS already exists." 
else
  ln -s ../vars/terraform.tfvars.json terraform/terraform.tfvars.json
  echo "Link $LINK_TERRAFORM_VARS created." 
fi
echo ">>>>> PREPARING DONE"