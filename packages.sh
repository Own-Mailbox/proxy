#!/bin/bash

apt-get update
apt-get -y upgrade

apt-get -y install apt-utils apt-transport-https
apt-get -y remove resolvconf openresolv network-manager

### Install some required packages.
apt-get -y install \
    build-essential git autotools-dev cdbs debhelper \
    dh-autoreconf dpkg-dev gettext libev-dev libpcre3-dev \
    libudns-dev pkg-config fakeroot libmysqlclient-dev \
    mysql-server postfix postfix-mysql apache2 bind9
