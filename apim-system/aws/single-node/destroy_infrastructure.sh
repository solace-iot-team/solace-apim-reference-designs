#!/bin/bash
# Destroys entire infrastructure:
#
# - AWS infrastructure
# - self-contained mongodb database 
# - aws-cloudwatch logs 

echo ">>>>> DESTROYING ENTIRE SELF_CONTAINED ASYNC-API-PLATFORM"
echo ">>>>> EVERYTHING WILL GET REMOVED (Database, Logs,...) "
echo " "
read -r -p "Are you sure? [y/N] " response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo ">>>>> DESTROYING STARTED ..."
    cd ansible
    echo "> invoking ansible-playbook prepare_destroy_infrastructure.yml"
    ansible-playbook prepare_destroy_infrastructure.yml
    echo "> invoking ansible-playbook remove_ip_mongodbcloud.yml"
    ansible-playbook remove_ip_mongodbcloud.yml
    cd ../terraform
    echo "> invoking terraform destroy -auto-approve"
    terraform destroy -auto-approve
    cd ..
    echo ">>>>> DESTROYING COMPLETED"
else
    echo "<<<<< ABORTED - NOTHING DESTROYED"
fi



