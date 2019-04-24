#!/usr/bin/env bash

for host in "$@"; do {
echo $host
 ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${host} -t 'cat <<EOF > /etc/profile.d/pgbench-test_env.sh
 export GLUSTER_PROFILER_RESULTS=/home/gluster-profiler-$HOSTNAME-$(date +%Y%m%d_%H%M%S)
 export MON_INTERVAL=10'

 ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${host} -t 'mkdir -p $GLUSTER_PROFILER_RESULTS'

 ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${host} -t 'nohup top -bd $MON_INTERVAL > $GLUSTER_PROFILER_RESULTS/top_proc.$HOSTNAME.txt
  nohup top -bHd $MON_INTERVAL > $GLUSTER_PROFILER_RESULTS/top_thr.$HOSTNAME.txt
  nohup iostat -Ntkdx $MON_INTERVAL >$GLUSTER_PROFILER_RESULTS/iostat.$HOSTNAME.txt
  nohup vmstat -t $MON_INTERVAL > $GLUSTER_PROFILER_RESULTS/vmstat.$HOSTNAME.txt
  nohup sar -n DEV -Br $MON_INTERVAL > $GLUSTER_PROFILER_RESULTS/sar.$HOSTNAME.txt '
} done
