disk=$1

echo "Creating pv"
pvcreate $disk 

vgcreate postgresql $disk

lvcreate -n pg_data -l 100%PVS postgresql $disk

mkfs.xfs /dev/postgresql/pg_data

mount /dev/postgresql/pg_data /var/lib/pgsql/data

chown postgres:postgres  /var/lib/pgsql/data

postgresql-setup initdb
