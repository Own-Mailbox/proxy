FROM debian:jessie
# ENV container docker
# # Don't start any optional services except for the few we need.
# RUN find /etc/systemd/system \
#          /lib/systemd/system \
#          -path '*.wants/*' \
#          -not -name '*journald*' \
#          -not -name '*systemd-tmpfiles*' \
#          -not -name '*systemd-user-sessions*' \
#          -exec rm \{} \;
# RUN systemctl set-default multi-user.target
# # CMD ["/sbin/init"]

RUN export APP_DIR=$(pwd)
RUN mkdir /host/

COPY settings.sh /host/

### Update and upgrade and install some other packages.
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install apt-utils apt-transport-https apache2 && \
    apt-get -y install rsyslog logrotate logwatch ssmtp wget

### Install mysql db
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server

### Install some required packages.
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
        build-essential git autotools-dev cdbs debhelper \
        dh-autoreconf dpkg-dev gettext libev-dev libpcre3-dev \
        libudns-dev pkg-config fakeroot libmysqlclient-dev \
        postfix postfix-mysql apache2 bind9 phpmyadmin tor

#########################################################
#           Run configuration scripts                   #
#########################################################
COPY scripts/cfg/ /
COPY src/ /src
COPY dockercfg.sh /
RUN chmod 775 dockercfg.sh && ./dockercfg.sh

CMD ["/bin/bash"]
EXPOSE 80 443 53 6565
