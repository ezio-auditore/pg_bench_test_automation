#!/usr/bin/env bash

ssh root@$1 'gluster volume profile vmstore info' > $RESULTS_MASTER/gprofile-vmstore.$2.txt