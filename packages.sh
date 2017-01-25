#!/bin/bash -xe

### automatic installation
export DEBIAN_FRONTEND="noninteractive"

### get $DBUSER, $DBPASS, etc.
source /proxy/settings.sh

apt-get update
apt-get -y upgrade

apt-get -y install apt-utils apt-transport-https debconf-utils
apt-get -y remove resolvconf openresolv network-manager

### Install some required packages.
debconf-set-selections config/debconf.seed
apt-get -y install \
    build-essential git autotools-dev cdbs debhelper \
    dh-autoreconf dpkg-dev gettext libev-dev libpcre3-dev \
    libudns-dev pkg-config fakeroot libmysqlclient-dev \
    postfix postfix-mysql apache2 bind9

# ### Install mysql-server
# debconf-set-selections <<< "mysql-server mysql-server/root_password password '$DBPASS'"
# debconf-set-selections <<< "mysql-server mysql-server/root_password_again password '$DBPASS'"
# apt-get -y install mysql-server
