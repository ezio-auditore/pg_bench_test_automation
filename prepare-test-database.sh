LOG_FILE=/var/log/pg-bench-results/prepare-test-db.log
su - postgres -c "createdb pgbench"

su - postgres -c "time pgbench -i -s 4000 pgbench" >> $LOG_FILE 2>&1

echo "Done setting databse"
