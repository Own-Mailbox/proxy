FROM ubuntu:16.04

ENV container docker
# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
         /lib/systemd/system \
         -path '*.wants/*' \
         -not -name '*journald*' \
         -not -name '*systemd-tmpfiles*' \
         -not -name '*systemd-user-sessions*' \
         -exec rm \{} \;
RUN systemctl set-default multi-user.target
CMD ["/sbin/init"]

### Update and upgrade and install some other packages.
RUN apt-get update && \
    apt-get -y upgrade
RUN apt-get -y install apt-utils apt-transport-https && \
    apt-get -y remove resolvconf openresolv network-manager

### Install some required packages.
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
        build-essential git autotools-dev cdbs debhelper \
        dh-autoreconf dpkg-dev gettext libev-dev libpcre3-dev \
        libudns-dev pkg-config fakeroot libmysqlclient-dev \
        mysql-server postfix postfix-mysql apache2 bind9

#COPY postfix.init.d /etc/init.d/postfix


