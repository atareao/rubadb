#!/bin/sh
#set -eo

if [ -d "/app/.config/rustic/" ]; then
    if [ -n "$MARIADB_HOST" ] && [ -n "$MARIADB_PORT" ] && [ -n "$MARIADB_PASS" ]; then
        echo "=== Backup Mariadb ${MARIADB_HOST} ==="
        mariadb-dump --all-databases \
                     --host=$MARIADB_HOST \
                     --port=$MARIADB_PORT \
                     --password=$MARIADB_PASS | gzip > "/app/backup/db/${MARIADB_HOST}_dump.sql.gz"
    fi
    if [ -n "$POSTGRESQL_HOST" ] && [ -n "$POSTGRESQL_PORT" ] && [ -n "$POSTGRESQL_USER" ] && [ -n "$POSTGRESQL_PASS" ]; then
        echo "=== Backup Postgresql ${POSTGRESQL_HOST} ==="
        export PGPASSWORD="$POSTGRESQL_PASS"
        pg_dump --host="$POSTGRESQL_HOST" \
                --port="$POSTGRESQL_PORT" \
                --username="$POSTGRESQL_USER" \
                --dbname="$DB" | gzip > "/app/backup/db/${POSTGRESQL_HOST}_dump.sql.gz"
    fi
    for file in $(find /app/.config/rustic -type f -name "*.toml"); do
        rustic -P $(basename "$file" | sed 's/\.toml$//') backup
    done
fi
