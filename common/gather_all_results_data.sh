#!/usr/bin/env bash
mkdir -p $RESULTS_MASTER/hosts_stats_master
for host in "$@"; do {
echo $host
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${host}  -t 'echo TAR_FILE_NAME=/home/hosts_stats-$(date +%Y%m%d_%H%M%S)-$HOSTNAME.tar.gz >> /etc/profile.d/pgbench-test_env.sh'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${host}  'tar -zcvf $TAR_FILE_NAME $GLUSTER_PROFILER_RESULTS'
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${host}:$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${host} 'echo $TAR_FILE_NAME') $RESULTS_MASTER/hosts_stats_master
} done