#!/bin/bash
# Bootstraps infrastructure and deploys self-contained setup
#
# Precondition: prepare_automation_configuration.sh got executed and vars got adjusted
#

echo ">>>>> Bootstraping SINGLE_NODE ASYNC-API-PLATFORM"

LOCAL_ANSIBLE_VARS=vars/sensitive_ansible_vars.yml
if [[ -f "$LOCAL_ANSIBLE_VARS" ]]; then
  echo "Checks ok"
else
  echo "$LOCAL_ANSIBLE_VARS must be in place. Please execute prepare_automation_configuration.sh first." 
  exit 1;
fi

cd ansible
echo "> invoking ansible-playbook create_local_ssh.yml"
ansible-playbook create_local_ssh.yml
cd ../terraform
echo "> invoking terraform init"
terraform init
echo "> invoking apply -auto-approve"
terraform apply -auto-approve
cd ../ansible
echo "> invoking ansible-playbook register_ip_mongodbcloud.yml"
ansible-playbook register_ip_mongodbcloud.yml
echo "> invoking ansible-playbook site.yml"
ansible-playbook site.yml

echo ">>>>> Bootstrapping DONE"