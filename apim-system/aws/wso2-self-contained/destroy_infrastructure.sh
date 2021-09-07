#!/bin/bash
# Destroys entire infrastructure:
#
# - AWS infrastructure
# - self-contained mongodb database 
# - aws-cloudwatch logs 

echo ">>>>> DESTROYING ENTIRE WSO2_SELF_CONTAINED ASYNC-API-PLATFORM"
echo ">>>>> EVERYTHING WILL GET REMOVED (Database, Logs,...) "
echo " "
read -r -p "Are you sure? [y/N] " response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo ">>>>> DESTROYING STARTED ..."
    cd ansible
    ansible-playbook prepare_destroy_infrastructure.yml
    cd ../terraform
    terraform destroy -auto-approve
    cd ..
    echo ">>>>> DESTROYING COMPLETED"
else
    echo "<<<<< ABORTED - NOTHING DESTROYED"
fi



