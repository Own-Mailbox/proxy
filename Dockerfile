FROM debian:stretch

RUN export APP_DIR=$(pwd)
RUN mkdir /host/

COPY settings.sh /host/

### Update and upgrade and install some other packages.
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install apt-utils apt-transport-https apache2 && \
    apt-get -y install rsyslog logrotate logwatch ssmtp wget whois \
    dovecot-common

### Install maria db
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mariadb-client \
                libmariadbclient-dev mariadb-common mariadb-server \
                default-libmysqlclient-dev

### Start the mysql server && install some required packages
### noninteractive is required in order to avoid postfix prompts
RUN /etc/init.d/mysql start && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
        build-essential git autotools-dev cdbs debhelper \
        dh-autoreconf dpkg-dev gettext libev-dev libpcre3-dev \
        libudns-dev pkg-config fakeroot phpmyadmin tor \
        postfix postfix-pcre postfix-mysql apache2 bind9 systemd-sysv devscripts

### Run configuration scripts
COPY scripts/cfg/ /
COPY src/ /src
COPY dockercfg.sh /
COPY init.sh /

RUN chmod 775 dockercfg.sh init.sh && ./dockercfg.sh

### Setup Bind9 to use seperate logs
COPY scripts/bind/* /etc/bind/named.conf.log
RUN echo 'include "/etc/bind/named.conf.log";' >> /etc/bind/named.conf
RUN mkdir /var/log/bind && chown bind:bind /var/log/bind && \
          service bind9 restart

CMD ./init.sh
EXPOSE 80 443 53 6565
