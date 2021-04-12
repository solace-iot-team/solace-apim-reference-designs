#!/bin/bash
# Bootstraps infrastructure and deploys self-contained setup
echo ">>>>> Bootstraping SELF_CONTAINED ASYNC-API-PLATFORM"

cd ansible
ansible-playbook create_local_ssh.yml
cd ../terraform
terraform init
terraform apply -auto-approve
cd ../ansible
ansible-playbook site.yml

echo ">>>>> Bootstrapping DONE"