#!/bin/bash -xe

### get $DBUSER, $DBPASS, etc.
source /proxy/settings.sh

### create the database and user
mysql='mysql --defaults-file=/etc/mysql/debian.cnf'
$mysql < config/db.sql
$mysql -e "GRANT ALL ON proxy.* TO $DBUSER@localhost IDENTIFIED BY '$DBPASS';"

### install sni2torproxy
cd /root/
git clone https://github.com/pparent76/sni2tor-proxy.git
cd sni2tor-proxy
./autogen.sh
./configure
make
make install

### Client-Server_Communication
cd /root/
git clone https://github.com/pparent76/Own-Mailbox_Client-Server_Commnucation.git
mkdir /var/www/html/request-omb
cp Own-Mailbox_Client-Server_Commnucation/server/* /var/www/html/request-omb/
# create and copy your global_variables.php in /var/www/html/request-omb/

### Configure postfix.
cd /root/
git clone https://github.com/pparent76/postfix-smpt2tor-relay.git
# copy files in postfix-cfg in /etc/config/postfix
# edit /etc/config/transport.mysql and add your login to the database
# copy files in scripts/ in /usr/lib/postfix/
# add to /etc/postfix/master.cf:
# smtptor unix - - - - - smtp_tor

### Configure bind.
# setup your domain zone (omb.one file) in /var/lib/bind so that it can be updated
# Install dnsutils in order to have nsupdate.
# Allow your Ip to update domaines.

# zone "omb.one" IN {
#     type master;
#     file "/var/lib/bind/omb.one";
#     allow-update { 164.132.40.32; };
# };


### Setup apache2
a2enmod ssl
a2dissite "*"
rm /etc/apache2/sites-available/*
cp /proxy/config/apache2.conf /etc/apache2/sites-available/default
a2ensite default
service apache2 restart

### Setup hostname
echo "own-mailbox-proxy" > /etc/hostname
echo "127.0.0.1 own-mailbox-proxy" >> /etc/hosts

### Setup startup
cat <<EOF > /etc/rc.local
#!/bin/bash

sni2torproxy -p 443 -l 443 --dbuser $DBUSER --dbpasswd $DBPASS --dbname $DBNAME &
sni2torproxy -p 993 -l 993 --dbuser $DBUSER --dbpasswd $DBPASS --dbname $DBNAME &

exit 0
EOF
chmod +x /etc/rc.local

### Setup iptables
iptables -F
ip6tables -F
/proxy/config/setup-iptables.sh
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

### Reboot
echo "Please reboot..."
