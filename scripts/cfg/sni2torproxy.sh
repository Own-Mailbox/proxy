#!/bin/bash -x
### install sni2torproxy

source /host/settings.sh

dir=/opt/Own-Mailbox/sni2tor-proxy
rm -rf $dir
git clone https://github.com/Own-Mailbox/sni2tor-proxy.git $dir
cd $dir
./autogen.sh
./configure
make
make install

### start sni2torproxy on startup
cat <<EOF > /etc/rc.local
#!/bin/bash

sni2torproxy -p 443 -l 443 --dbuser $DBUSER --dbpasswd $DBPASS --dbname $DBNAME &
sni2torproxy -p 993 -l 993 --dbuser $DBUSER --dbpasswd $DBPASS --dbname $DBNAME &

exit 0
EOF
chmod +x /etc/rc.local

### setup a cron job to monitor and restart sni2torproxy
cp $APP_DIR/src/restart-sni2tor.sh /usr/local/sbin/sni2tor.sh
chmod +x /usr/local/sbin/sni2tor.sh
mkdir -p /etc/cron.d/
cat <<'EOF' > /etc/cron.d/sni2tor
*/2 * * * * root /usr/local/sbin/sni2tor.sh >/dev/null 2>&1
EOF
chmod +x /etc/cron.d/sni2tor
