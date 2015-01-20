FROM ubuntu:trusty
MAINTAINER johnny@itfolks.com.au

RUN apt-get install -y mysql-client

ADD mysql-backuper.sh /usr/local/bin/mysql-backuper.sh
RUN chmod a+x /usr/local/bin/mysql-backuper.sh

ADD ./startup.sh /opt/startup.sh
RUN chmod a+x /opt/startup.sh
CMD ["/bin/bash", "/opt/startup.sh"]

ENV DB_ENV_MYSQL_USER admin
ENV BACKUP_CRON_TIME 0 * * * *
ENV BACKUP_ENABLED yes