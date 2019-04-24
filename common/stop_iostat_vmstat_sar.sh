#!/usr/bin/env bash

for host in "$@"; do {
echo $host
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${host} -t  'kill -9  $(pgrep -f "sar");
kill -9  $(pgrep -f "iostat");
kill -9  $(pgrep -f "vmstat");
kill -9  $(pgrep -f "top -bHd");
kill -9  $(pgrep -f "vtop -bd");
kill -9  $(pgrep -f "sar")'

} done