#!/bin/bash
set -euo pipefail

ansible_dir=deployment/ansible
terraform_dir=deployment/terraform
terraform -chdir=${terraform_dir} init
if [ "$1" == "--redeploy" ]; then
    terraform -chdir=${terraform_dir} destroy --auto-approve
fi
if [ "$1" == "--destroy" ]; then
    terraform -chdir=${terraform_dir} destroy --auto-approve
else
    terraform -chdir=${terraform_dir} apply --auto-approve
    ANSIBLE_CONFIG=${ansible_dir}/ansible.cfg ansible-playbook ${ansible_dir}/main.yml -i ${ansible_dir}/inventories/hosts.ini -l all -f 10 --private-key ${ansible_dir}/ansible.key -u ansible --vault-password-file ${ansible_dir}/vault-password.password -t all --diff
fi
