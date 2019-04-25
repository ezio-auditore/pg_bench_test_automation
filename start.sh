#!/usr/bin/env bash

echo "Setting up new VM"
python ./pre_setup/setup_vm.py && python ./pre_setup/add_disk.py

export VM_IP=`python ./pre_setup/retrieve_ip.py` && echo $VM_IP

export PROJECT_HOME="$(git rev-parse --show-toplevel)" && echo $PROJECT_HOME

export RESULTS_MASTER="$PROJECT_HOME/results-master-$(date +%Y%m%d_%H%M%S)"

mkdir -p $RESULTS_MASTER

mapfile -t HOSTS < <(cat ./hosts.txt)

echo "Removing old keys if present"
if test -f $HOME/.ssh/authorized_keys; then
  if grep -v $VM_IP $HOME/.ssh/authorized_keys > $HOME/.ssh/tmp; then
    cat $HOME/.ssh/tmp > $HOME/.ssh/authorized_keys && rm $HOME/.ssh/tmp;
  else
    rm $HOME/.ssh/authorized_keys && rm $HOME/.ssh/tmp;
  fi;
fi

sshpass -f vm_pass.txt ssh-copy-id  -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$VM_IP && \

echo "ssh-copy-id succedded. Initiating Ansible playbook"

ansible-playbook -u root -i $VM_IP, ./ansible/playboooks/00_main.yml -v

sshpass -f vm_pass.txt ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$VM_IP  'firewall-cmd --reload'


echo "Fetching gluster profile details pretest"
bash ./common/gather_gluster_prof_stats.sh $(echo "${HOSTS[0]}") pretest

echo "Setting up pgbencher"
bash ./post_setup/settup_pg_bencher.sh



ansible-playbook -i $VM_IP, ./pgbencher/main.yml -v &

bash ./common/run_iostat_vmstat_sar.sh  $(echo "${HOSTS[@]}") &

wait

bash ./common/stop_iostat_vmstat_sar.sh $(echo "${HOSTS[@]}")
echo "Finished running pgbencher"

echo "Fetching gluster profile details posttest"

bash ./common/gather_gluster_prof_stats.sh $(echo "${HOSTS[0]}") posttest

echo "Gathering all data from all hosts"
bash ./common/gather_all_results_data.sh $(echo "${HOSTS[@]}")




