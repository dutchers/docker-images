#!/bin/bash
set -e

PG_HBA="$PGDATA/pg_hba.conf"
PG_CONF="$PGDATA/postgresql.conf"



if [ $REPLICATION_ROLE == 'standalone' ]; then
    # The below is not indented because bash demands tabs for continuation lines

    # Create database and user with limited proviliges
    psql --username postgres <<-EOSQL
       CREATE DATABASE ${DATABASE};
       CREATE ROLE ${PROJECT_USER} ENCRYPTED PASSWORD '${PROJECT_PASSWORD}' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;
       GRANT ALL PRIVILEGES ON DATABASE ${DATABASE} to ${PROJECT_USER};
EOSQL

    echo "set project data user"

fi

if [ $REPLICATION_ROLE == 'master' ]; then
    # The below is not indented because bash demands tabs for continuation lines

    # Create Replication user
    psql --username postgres  <<-EOSQL
        CREATE ROLE ${REPLICATION_USER} ENCRYPTED PASSWORD '${REPLICATION_PASSWORD}' REPLICATION LOGIN;
EOSQL

    echo "Made replicaiton"

    # TODO: Set up archiving

    # Create database and user with limited proviliges
    psql --username postgres <<-EOSQL
       CREATE DATABASE ${DATABASE};
       CREATE ROLE ${PROJECT_USER} ENCRYPTED PASSWORD '${PROJECT_PASSWORD}' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;
       GRANT ALL PRIVILEGES ON DATABASE ${DATABASE} to ${PROJECT_USER};
EOSQL

    echo "set project data user"


    # End MASTER SETUP
fi

if [ $REPLICATION_ROLE == 'slave' ]; then

    # Master takes a few seconds to get up and running lets wait for it.
    sleep 10

    # Stop postgres - there is no reason for it to be running during slave initialization
    gosu postgres pg_ctl -D "$PGDATA" -m fast -w stop

    # SLAVE SETUP
    export PGPASSFILE=/.pgpass
    echo "*:*:*:*:${REPLICATION_PASSWORD}" > /.pgpass
    chmod 600 /.pgpass

    echo "Cleaning up old cluster directory"
    rm -rf ${PGDATA:?}/*

    echo "Starting base backup as replicator"
    echo "pg_basebackup -h ${MASTERDB_PORT_5432_TCP_ADDR} -U ${REPLICATION_USER} -D ${PGDATA} -vP"
    pg_basebackup -h ${MASTERDB_PORT_5432_TCP_ADDR} -U ${REPLICATION_USER} -D ${PGDATA} -vP

    echo "Creating postgresql.conf..."
    echo "hot_standby = on" >> $PGDATA/postgresql.conf

    echo "Writing recovery.conf file"
    cat > ${PGDATA}/recovery.conf <<-EOS
        standby_mode = 'on'
        primary_conninfo = 'host=${MASTERDB_PORT_5432_TCP_ADDR} port=5432 user=${REPLICATION_USER} password=${REPLICATION_PASSWORD}'
        trigger_file = '/tmp/postgresql.trigger'
EOS

    mkdir /var/lib/postgresql/archive
    chown postgres:postgres /var/lib/postgresql/archive
    chown -R postgres:postgres ${PGDATA}
    chmod 700 /var/lib/postgresql/data

fi

##
## Below applies to all servers
##

# Setting to 0.0.0.0 cause networks are adhoc.
# TODO: Figure out how to pull the network from the ifconfig or test using link to feed slave to master.
# Not secuirty problem unless you expose 5432 to the world, which you should never do.
echo "host replication ${REPLICATION_USER} 0.0.0.0/0 md5" >> $PG_HBA

echo "wrote to pg_hba"

# Set Write Ahead Log to hot_standby
sed -i -e "s/#wal_level = minimal/wal_level = hot_standby/" $PG_CONF
echo "set wal level"

# Allow 3 replicators.  We could set to 1 but let's leave some slots open incase we
# need them for various management purposes such as creating a new master or slave
sed -i -e "s/#max_replication_slots = 0/max_replication_slots = 3/" $PG_CONF
sed -i -e "s/#max_wal_senders = 0/max_wal_senders = 3/" $PG_CONF
echo "set rep slots"

 # Set wal segments to 160 MB, This affects much data there is for recovery
 # should the replicator go offline for a short time.
sed -i -e "s/#checkpoint_segments = 3/checkpoint_segments = 10/" $PG_CONF
sed -i -e "s/#wal_keep_segments = 0/wal_keep_segments = 10/" $PG_CONF

echo "set segments"

# Set Write Ahead Log to hot_standby
sed -i -e "s/#wal_level = minimal/wal_level = hot_standby/" $PG_CONF

# Allow 3 replicators.  We could set to 1 but we leave some slots open incase we
# need them for various management purposes such as creating a new master or slave
sed -i -e "s/#max_replication_slots = 0/max_replication_slots = 3/" $PG_CONF

 # Set wal segments to 160 MB, This affects much data there is for the replicator
 # should the replicator go offline or the network hiccup.
sed -i -e "s/#checkpoint_segments = 3/checkpoint_segments = 10/" $PG_CONF
sed -i -e "s/#wal_keep_segments = 0/wal_keep_segments = 10/" $PG_CONF
