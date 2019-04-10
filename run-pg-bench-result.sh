echo "Starting pg-bench in iteratons of 3"

PG_BENCH_REULTS=/var/log/pg-bench-results/pg-bench-results.txt

su - postgres -c "
for i in {1 .. 3}
 do 
    pgbench -c 10 -t 500 -r pgbench ; pgbench -c 10 -t 1000 -r pgbench ; pgbench -c 10 -t 2000 -r; pgbench -c 10 -t 4000" >> $PG_BENCH_REULTS 2>&1

echo "Done" 
