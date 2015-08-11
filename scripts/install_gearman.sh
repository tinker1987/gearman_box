#!/bin/bash

# installing libraries
function setup_libs(){
	apt-get update
	apt-get -y install libevent-2.0-5
	apt-get -y install build-essential libboost-thread-dev libboost-program-options-dev libevent-dev libmysqld-dev uuid-dev gperf
}


# making Gearman
function setup_gearman(){
	cd /opt
	wget "https://launchpad.net/gearmand/1.2/1.1.12/+download/gearmand-1.1.12.tar.gz"
	tar xvfz gearmand-1.1.12.tar.gz
	cd gearmand-1.1.12/
	./configure --with-mysql=/usr/bin/mysql_config
	make && make install && ldconfig
	ln -s /usr/local/sbin/gearmand /usr/sbin/gearmand

	touch /usr/local/etc/gearmand.conf
}

# installing Gearman php client
function setup_php_gearman(){
	pecl install gearman
	echo "extension=gearman.so" > /etc/php5/conf.d/gearman.ini
}

# add user
function create_user(){
	groupadd gearman
	useradd -g gearman gearman
}

# create log folders and files
function create_logs(){
	mkdir /var/log/gearmand
	touch /var/log/gearmand/gearmand.log
	touch /var/log/gearmand/workers.log
	chown -R gearman /var/log/gearmand
	chgrp -R gearman /var/log/gearmand
	chmod -R 0777 /var/log/gearmand
}

# create folder for pid files
function create_pid_dir(){
	mkdir /var/run/gearmand
	chown -R gearman /var/run/gearmand
	chgrp -R gearman /var/run/gearmand
	chmod -R 0777 /var/run/gearmand
}

# install supervisor
function setup_supervisor(){
	apt-get -y install python-setuptools
	easy_install supervisor

	touch /var/log/supervisord.log
	chown gearman /var/log/supervisord.log
	chmod 0777 /var/log/supervisord.log
}

function usage(){
	echo "Usage:"
	echo "-l : setup required libraries"
	echo "-g : compile libgearman"
	echo "-p : setup php gearman extension"
	echo "-u : create gearman user"
	echo "-o : create log files"
	echo "-d : create pid-files directory"
	echo "-s : setup supervisord"
	echo "-m : run mysql migration "
}

function run_mysql_migration(){
	# If You will change password here than You need to change it in ./gearmand file (DB_PASS)
	PASSWORD="gpassword*"
	mysql -u root -p"root" -e "CREATE DATABASE gearman; USE gearman; CREATE TABLE gearman_queue (unique_key varchar(255) DEFAULT NULL,function_name varchar(255) DEFAULT NULL,priority int(11) DEFAULT NULL, data longblob, when_to_run bigint(20) DEFAULT NULL, UNIQUE KEY unique_key (unique_key,function_name) ) ENGINE=InnoDB DEFAULT CHARSET=utf8;CREATE USER 'gearman'@'%' IDENTIFIED BY \"${PASSWORD}\"; GRANT ALL PRIVILEGES ON gearman.* TO 'gearman'@'%'; FLUSH PRIVILEGES;"
}

while getopts "lgpuodsm" OPTION
do
    case ${OPTION} in
    	l) SETUP_LIBS=Y
			;;
        g) SETUP_GEARMAN=Y
            ;;
        p) SETUP_PHP_EXTENSION=Y
            ;;
        u) CREATE_USER=Y
            ;;
        o) CREATE_LOGS=Y
            ;;
        d) CREATE_PID_DIR=Y
            ;;
        s) SETUP_SUPERVISOR=Y
            ;;
        m) MYSQL_MIGRATION=Y
            ;;
        *) usage
			exit
            ;;
    esac
done

if [ "${SETUP_LIBS}" == "Y" ]; then
	setup_libs
fi

if [ "${SETUP_GEARMAN}" == "Y" ]; then
	setup_gearman
fi

if [ "${SETUP_PHP_EXTENSION}" == "Y" ] ; then
	setup_php_gearman
fi

if [ "${CREATE_USER}" == "Y" ] ; then
	create_user
fi

if [ "${CREATE_LOGS}" == "Y" ] ; then
	create_logs
fi

if [ "${CREATE_PID_DIR}" == "Y" ] ; then
	create_pid_dir
fi

if [ "${SETUP_SUPERVISOR}" == "Y" ] ; then
	setup_supervisor
fi

if [ "${MYSQL_MIGRATION}" == "Y" ] ; then
	run_mysql_migration
fi