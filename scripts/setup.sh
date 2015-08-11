#!/bin/bash

function setup_node(){
	echo "Installing nodejs"
	cd /opt
	wget "https://nodejs.org/dist/v0.12.7/node-v0.12.7-linux-x64.tar.gz"
	tar xvfz node-v0.12.7-linux-x64.tar.gz > /dev/null 2>&1 
	ln -s /opt/node-v0.12.7-linux-x64/bin/node /usr/local/bin/node
	ln -s /opt/node-v0.12.7-linux-x64/bin/npm /usr/local/bin/npm
}

function setup_mysql(){
	sudo apt-get update
	echo "Installing mysql"
	sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password password root'
    sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password_again password root'
    sudo apt-get -y install mysql-server mysql-client
    sed -i '/bind-address/d' /etc/mysql/my.cnf
    service mysql restart
}

function base_setup(){
	echo "Base install"
	sudo apt-get update
	sudo apt-get -y install curl imagemagick imagemagick-common mc
}

while getopts "imn" OPTION
do
    case ${OPTION} in
    	i) BASE_SETUP=Y
			;;
        m) SETUP_MYSQL=Y
            ;;
        n) SETUP_NODE=Y
            ;;
        *) exit
            ;;
    esac
done

if [ "${BASE_SETUP}" == "Y" ]; then
	base_setup
fi

if [ "${SETUP_MYSQL}" == "Y" ]; then
	setup_mysql
fi

if [ "${SETUP_NODE}" == "Y" ] ; then
	setup_node
fi