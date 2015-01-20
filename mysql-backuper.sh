#!/bin/bash
: ${BACKUP_PATH:="/var/mysql-backup"}; : ${MYSQL_DEFAULTS_FILE:="/mysql.cnf"};

## MAIN

echo ">> using \$BACKUP_PATH: $BACKUP_PATH"
mkdir -p $BACKUP_PATH &> /dev/null

echo ">> backup of complete sql server"
mysqldump --defaults-file="$MYSQL_DEFAULTS_FILE" --all-databases > "$BACKUP_PATH/mysql-databases.sql"
