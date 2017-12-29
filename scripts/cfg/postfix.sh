#!/bin/bash -x
### Configure postfix.

source /host/settings.sh

# setup hostname
echo "own-mailbox-proxy" > /etc/hostname
echo "127.0.0.1 own-mailbox-proxy" >> /etc/hosts

cd /root/
git clone https://github.com/Own-Mailbox/postfix-smpt2tor-relay.git
cd postfix-smpt2tor-relay/
cp postfix-cfg/* /etc/config/postfix/

# ToDo: Edit /etc/config/transport.mysql and add your login to the database

cp scripts/* /usr/lib/postfix/
echo "smtptor unix - - - - - smtp_tor" >> /etc/postfix/master.cf
