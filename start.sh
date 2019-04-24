#!/usr/bin/env bash

python ./pre_setup/setup_vm.py && python ./pre_setup/add_disk.py

export VM_IP=`python ./pre_setup/retrieve_ip.py` && echo $VM_IP

export PROJECT_HOME="$(git rev-parse --show-toplevel)" && echo $PROJECT_HOME

echo "Removing old keys if present"
if test -f $HOME/.ssh/authorized_keys; then
  if grep -v $VM_IP $HOME/.ssh/authorized_keys > $HOME/.ssh/tmp; then
    cat $HOME/.ssh/tmp > $HOME/.ssh/authorized_keys && rm $HOME/.ssh/tmp;
  else
    rm $HOME/.ssh/authorized_keys && rm $HOME/.ssh/tmp;
  fi;
fi

sshpass -f vm_pass.txt ssh-copy-id  -o UserKnownHostsFile=/dev/null
-o StrictHostKeyChecking=no root@$VM_IP && \
echo "ssh-copy-id succedded. Initiating Ansible playbook"

ansible-playbook -u root -i $VM_IP, ./ansible/playboooks/00_main.yml -v

sshpass -f vm_pass.txt ssh -o StrictHostKeyChecking=no root@$VM_IP  'firewall-cmd --reload'

sh ./post_setup/settup_pg_bencher.sh

ansible-playbook -i $VM_IP, ./pgbencher/main.yml -v



