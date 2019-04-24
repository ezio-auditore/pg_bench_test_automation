#!/usr/bin/env bash

echo "removing old clone of pgbencher"

if [ -d "$PROJECT_HOME/pgbencher" ]; then rm -Rf $PROJECT_HOME/pgbencher; fi

git clone https://github.com/ezio-auditore/pgbencher.git

cd pgbencher

export PGBENCHER_HOME="$(git rev-parse --show-toplevel)" && echo $PGBENCHER_HOME

sed "s/localhost/$VM_IP/g" $PGBENCHER_HOME/defaults/main.yml > $PGBENCHER_HOME/config.yml
