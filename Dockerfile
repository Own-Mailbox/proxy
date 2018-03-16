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
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install apt-utils apt-transport-https && \
    apt-get -y remove resolvconf openresolv network-manager && \
    apt-get -y install rsyslog logrotate logwatch ssmtp

### Install mariadb.
RUN apt-get -y install software-properties-common && \
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 && \
    add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://ftp.utexas.edu/mariadb/repo/10.2/ubuntu xenial main' && \
    apt-get update
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y install mariadb-server mariadb-client

### Install some required packages.
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
        build-essential git autotools-dev cdbs debhelper \
        dh-autoreconf dpkg-dev gettext libev-dev libpcre3-dev \
        libudns-dev pkg-config fakeroot libmysqlclient-dev \
        postfix postfix-mysql apache2 bind9 phpmyadmin tor

#COPY config/postfix.init.d /etc/init.d/postfix


