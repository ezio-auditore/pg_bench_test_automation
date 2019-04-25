#!/usr/bin/env bash

for host in "$@"; do {
echo $host
 ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${host} -tt 'cat <<EOF > /etc/profile.d/pgbench-test_env.sh
 export GLUSTER_PROFILER_RESULTS=/home/gluster-profiler-$HOSTNAME-$(date +%Y%m%d_%H%M%S)
 export MON_INTERVAL=10'

 ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${host} -tt 'mkdir -p $GLUSTER_PROFILER_RESULTS'

 ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${host} -tt " top -bd \$MON_INTERVAL > \$GLUSTER_PROFILER_RESULTS/top_proc.\$HOSTNAME.txt &
   top -bHd \$MON_INTERVAL > \$GLUSTER_PROFILER_RESULTS/top_thr.\$HOSTNAME.txt &
   iostat -Ntkdx \$MON_INTERVAL >\$GLUSTER_PROFILER_RESULTS/iostat.\$HOSTNAME.txt &
   vmstat -t \$MON_INTERVAL > \$GLUSTER_PROFILER_RESULTS/vmstat.\$HOSTNAME.txt &
   sar -n DEV -Br \$MON_INTERVAL > \$GLUSTER_PROFILER_RESULTS/sar.\$HOSTNAME.txt & "
} done
