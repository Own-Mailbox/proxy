#!/bin/bash -x
### Configure postfix.

echo "Configuring postfix"

source /host/settings.sh

# setup hostname
echo "own-mailbox-proxy" > /etc/hostname
echo "127.0.0.1 own-mailbox-proxy" >> /etc/hosts

dir=/opt/Own-Mailbox/postfix-smpt2tor-relay
rm -rf $dir
git clone https://github.com/Own-Mailbox/postfix-smpt2tor-relay.git $dir
cd $dir
cp postfix-cfg/* /etc/postfix/

# ToDo: Edit /etc/config/transport.mysql and add your login to the database

cp scripts/* /usr/lib/postfix/

sed -i /etc/postfix/master.cf -e '/^smtptor unix - - - - - smtp_tor$/d'
echo "smtptor unix - - - - - smtp_tor" >> /etc/postfix/master.cf
