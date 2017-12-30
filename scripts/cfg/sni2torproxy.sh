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

### create a script to check and restart sni2tor
cat <<'EOF' > /usr/local/sbin/sni2tor.sh
#!/bin/bash

source /host/settings.sh

nb=$(ps -ae | grep sni2torproxy |  wc -l)
ps -ae | grep sni2torproxy >/dev/null 2>1
rm /tmp/wget-ok > /dev/null 2>1
wget --tries=10 --timeout=30 https://$FQDN/OK -O /tmp/wget-ok >/tmp/wget-sni-res 2>&1
ok=$(cat /tmp/wget-ok)

if [  "$ok" != "OK"  ]; then
        sleep 15;
        wget --timeout=30 https://$FQDN/OK -O /tmp/wget-ok >>/tmp/wget-sni-res 2>&1
        ok=$(cat /tmp/wget-ok)
fi

if [  "$ok" != "OK"  ]; then
        sleep 15;
        wget --timeout=30 https://$FQDN/OK -O /tmp/wget-ok >>/tmp/wget-sni-res 2>&1
        ok=$(cat /tmp/wget-ok)
fi


if [ "$nb" -lt "2" ] || [ "$ok" != "OK" ] ;  then
echo "bad restarting sni2torproxy: nbprocess:$nb wget:$ok"
cat /tmp/wget-sni-res

#restarting tor
killall tor
fuser -k  9050/tcp
sleep 1;
find /var/lib/tor -mindepth 1 -maxdepth 1 -type f -mtime +21 -user debian-tor -regex '.*/core\(\.[0-9]+\)?' -exec rm '{}' +
tor&

#killall sni2torproxy
fuser -k 443/tcp
fuser -k 993/tcp
fuser  443/tcp
fuser  993/tcp

sleep 1;
killall -9  sni2torproxy >/dev/null 2>&1;
sni2torproxy -p 443 -l 443 --dbuser $DBUSER --dbpasswd $DBPASS --dbname $DBNAME &
sni2torproxy -p 993 -l 993 --dbuser $DBUSER --dbpasswd $DBPASS --dbname $DBNAME &
else
true
#echo "ok:$nb"
fi

EOF

### make it executable
chmod +x /usr/local/sbin/sni2tor.sh

### setup a cron job to run the monitoring script
mkdir -p /etc/cron.d/
cat <<'EOF' > /etc/cron.d/sni2tor
*/2 * * * * root /usr/local/sbin/sni2tor.sh >/dev/null 2>&1
EOF
chmod +x /etc/cron.d/sni2tor
