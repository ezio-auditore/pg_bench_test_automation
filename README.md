# pg-bench-test-automation

**A  benchmarking tool for [ovirt](https://github.com/ovirt) storage environments.**

***Prerequisites***

+ ovirt engine sdk
+ psycopg2
+ ansible
+ Paswordless ssh connection between the hosts
+ edit hosts.txt
+ Ovirt Api url
+ Edit connection url and creds in ./presetup/connection.py

*Optional*

+ Fork this [wilfriedroset/pgbencher](https://github.com/wilfriedroset/pgbencher)
and edit $PGBENCHER_ROOT/defaults/main.yml > `bench_plan`
+ Push changes to your git repository
+ Edit ./post_setup/settup_pg_bencher.sh > git clone <Your repo here>

**To run test**

```
⌁ [pg_bench_test_automation] master+ ± bash start.sh
```


The results will be stored in a folder inside $PROJECT_HOME as (results-master-*)
