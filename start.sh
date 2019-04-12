#!/usr/bin/env bash

python ./pre_setup/setup_vm.py && python ./pre_setup/add_disk.py
VM_IP=`python ./pre_setup/retrieve_ip.py` && echo $VM_IP

sshpass -f vm_pass.txt ssh-copy-id -o StrictHostKeyChecking=no root@$VM_IP && \
echo "ssh-copy-id succedded. Initiating Ansible playbook"

ansible-playbook -u root -i $VM_IP, ./ansible/playboooks/00_main.yml -v



