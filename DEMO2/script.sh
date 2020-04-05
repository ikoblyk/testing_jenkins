#!/bin/bash

DBNAME=CONFLUENCE
DBUSER=root
DBPASSWD=123456

echo "
app.confHome=/var/atlassian/application-data/confluence7_3_1
app.install.service$Boolean=true
portChoice=default
launch.application$Boolean=true
sys.adminRights$Boolean=true
sys.confirmedUpdateInstallationString=false
sys.installationDir=/opt/atlassian/confluence7_3_1
sys.languageId=en" > response.varfile

sudo apt-get update
sudo apt-get install -y mysql-server

export DEBIAN_FRONTEND=noninteractive

wget  https://product-downloads.atlassian.com/software/confluence/downloads/atlassian-confluence-7.3.1-x64.bin
sudo chmod u+x atlassian-confluence-7.3.1-x64.bin
sudo ./atlassian-confluence-7.3.1-x64.bin -q -varfile response.varfile

sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456'"


mysql -uroot -p$DBPASSWD -e "FLUSH PRIVILEGES"


echo "
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_bin
default-storage-engine=INNODB
max_allowed_packet=256M
innodb_log_file_size=2GB
sql_mode = NO_AUTO_VALUE_ON_ZERO
transaction-isolation=READ-COMMITTED
binlog_format=row" | sudo tee -a /etc/mysql/my.cnf

sudo /etc/init.d/mysql stop
sudo /etc/init.d/mysql start

mysql -uroot -p123456 -e "CREATE DATABASE CONFLUENCE CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
mysql -uroot -p123456 -e "GRANT ALL PRIVILEGES ON CONFLUENCE* TO 'root'@'localhost' IDENTIFIED BY '123456'"


sudo apt-get install -y libmysql-java
mv /usr/share/java/mysql-connector-java-5.1.45.jar /opt/atlassian/confluence7_3_1/confluence/WEB-INF/lib

for i in {1..200}; do echo "THIS IS DEVELOPERS BRANCH!!!!!!!!!!!!!!!!"; done


sudo /etc/init.d/confluence stop
sudo /etc/init.d/confluence start