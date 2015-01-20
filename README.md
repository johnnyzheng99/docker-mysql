### Backup

This is totaly optional - backup is disabled by default!  
In default it stores it's dumps beneath: __/var/mysql-backup__

* __BACKUP_ENABLED__
 * default null, needs 'yes' to be enabled
* __BACKUP\_CRON\_TIME__
 * default: _0 \* \* \* \*_ (hourly mysqldumps) - uses normal cron syntax

## Using the marvambass/mysql Container 

### Running MySQL

For the first start you'll need to provide the __ADMIN\_USER__ and __ADMIN\_PASSWORD__ variables

    docker run -d --name mysqlbackup --link db\
    -e 'BACKUP_ENABLED=yes' -e 'BACKUP_CRON_TIME=0 * * * *' \
    -v /tmp/mysqlbackup:/var/mysql-backup \
    johnnyzheng/mysql
_you need to provide the credentials only if you start the container for the first time (so it can initialize a new Database) or if you use the internal mysqldump backup mechanism_
