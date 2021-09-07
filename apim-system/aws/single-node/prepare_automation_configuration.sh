#!/bin/bash
echo ">>>>> PREPARING LOCAL CONFIGURATION FOR SINGLE-NODE ASYNC-API-PLATFORM"

ANSIBLE_CFG=ansible/ansible.cfg
if [[ -f "$ANSIBLE_CFG" ]]; then
   echo "$ANSIBLE_CFG already exists." 
else
  cp ansible/template_ansible.cfg ansible/ansible.cfg
  echo "$ANSIBLE_CFG created based on template." 
  echo "Please adjust content of this file before deploying infrastructure."
fi

LOCAL_ANSIBLE_VARS=vars/ansible_vars.yml
if [[ -f "$LOCAL_ANSIBLE_VARS" ]]; then
   echo "$LOCAL_ANSIBLE_VARS already exists." 
else
  cp vars/template_ansible_vars.yml vars/ansible_vars.yml
  echo "$LOCAL_ANSIBLE_VARS created based on template." 
  echo "Please adjust content of this file before deploying infrastructure."
fi

LOCAL_SENSITIVE_ANSIBLE_VARS=vars/sensitive_ansible_vars.yml
if [[ -f "$LOCAL_SENSITIVE_ANSIBLE_VARS" ]]; then
   echo "$LOCAL_SENSITIVE_ANSIBLE_VARS already exists." 
else
  cp vars/template_sensitive_ansible_vars.yml vars/sensitive_ansible_vars.yml
  echo "$LOCAL_SENSITIVE_ANSIBLE_VARS created based on template." 
  echo "Please adjust content of this file before deploying infrastructure."
fi

LOCAL_SENSITIVE_ORG_VARS=vars/sensitive_org_vars.yml
if [[ -f "LOCAL_SENSITIVE_ORG_VARS" ]]; then
   echo "LOCAL_SENSITIVE_ORG_VARS already exists."
else
  cp vars/template_sensitive_org_vars.yml vars/sensitive_org_vars.yml
  echo "LOCAL_SENSITIVE_ORG_VARS created based on template."
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