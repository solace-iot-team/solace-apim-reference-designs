#!/bin/bash
# Bootstraps infrastructure and deploys self-contained setup
echo ">>>>> Bootstraping SELF_CONTAINED ASYNC-API-PLATFORM"

cd ansible
echo "> invoking ansible-playbook create_local_ssh.yml"
ansible-playbook create_local_ssh.yml
cd ../terraform
echo "> invoking terraform init"
terraform init
echo "> invoking terraform apply -auto-approve"
terraform apply -auto-approve
cd ../ansible
echo "> invoking ansible-playbook site.yml"
ansible-playbook site.yml

echo ">>>>> Bootstrapping DONE"