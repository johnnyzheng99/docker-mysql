#/bin/bash

: ${DB_ENV_MYSQL_HOST:="db"}; : ${DB_ENV_MYSQL_USER:="admin"}; : ${DB_ENV_MYSQL_PASS:=""}; : ${MYSQL_DEFAULTS_FILE:="/mysql.cnf"}; : ${BACKUP_CRON_TIME:="0 * * * *"}; : ${BACKUP_ENABLED:="yes"};

## FUNCTIONS

function exit_if_no_credentials_provided {
  if [ "yes" != "$CREDENTIALS_PROVIDED" ]
  then
    >&2 echo ">> you need credentials for this action but no credentials were provided!";
    exit 1
  fi
}

function enable_backups {
  if [ -z ${BACKUP_CRON_TIME+x} ]
  then
    echo ">> no \$BACKUP_CRON_TIME set, using default value"
    BACKUP_CRON_TIME="0 * * * *"
  fi

  echo ">> using '$BACKUP_CRON_TIME' as \$BACKUP_CRON_TIME"
  echo "$BACKUP_CRON_TIME root /usr/local/bin/mysql-backuper.sh" >> /etc/crontab

  echo ">> creating $MYSQL_DEFAULTS_FILE file"
  create_mysql_defaults_file
  
  echo ">> starting cron daemon"
  cron -f &
}

function create_mysql_defaults_file {
cat <<EOF > "$MYSQL_DEFAULTS_FILE"
[client]
user="$DB_ENV_MYSQL_USER"
password="$DB_ENV_MYSQL_PASS"
host="$DB_ENV_MYSQL_HOST"
[mysqldump]
host="$DB_ENV_MYSQL_HOST"
EOF
}


## MAIN

# variables stuff
MY_IP=`ip a s eth0 | grep inet | awk '{print $2}' | sed 's/\/.*//g' | head -n1`

CREDENTIALS_PROVIDED="yes"
if [ -z ${DB_ENV_MYSQL_PASS+x} ]
then
  >&2 echo ">> no \$DB_ENV_MYSQL_PASS specified"
  CREDENTIALS_PROVIDED="no"
fi

# backup stuff
echo ">> enable auto-backups (mysqldump)"
echo ">> backups will be stored at default path"
echo ">> !! link or overwrite it to gain access !!"
exit_if_no_credentials_provided
enable_backups

echo ">> starting daemon"
/bin/bash -c "while true;do sleep ${SLEEP_SECONDS:-30};done"
