#!/bin/sh

###########################################################
#        This script allows to install directly
#           the proxy on a debian jessy machine
#           without any container.
###########################################################

export APP_DIR=$(pwd)
mkdir /host/
cp settings.sh /host/


### Update and upgrade and install some other packages.
apt-get update && apt-get -y upgrade
apt-get -y install apt-utils apt-transport-https && \
apt-get -y install rsyslog logrotate logwatch ssmtp

    
DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server

DEBIAN_FRONTEND=noninteractive apt-get -y install \
        build-essential git autotools-dev cdbs debhelper \
        dh-autoreconf dpkg-dev gettext libev-dev libpcre3-dev \
        libudns-dev pkg-config fakeroot libmysqlclient-dev \
        postfix postfix-mysql apache2 bind9 phpmyadmin tor
        
        
#########################################################
#           Run configuration scripts
#########################################################

scripts/cfg/apache2.sh
scripts/cfg/bind9.sh
scripts/cfg/cs-com.sh
scripts/cfg/db.sh
scripts/cfg/get-ssl-cert.sh
scripts/cfg/postfix.sh
scripts/cfg/sni2torproxy.sh
