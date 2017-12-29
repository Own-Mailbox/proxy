#!/bin/bash -x
### install sni2torproxy

source /host/settings.sh

cd /root/
git clone https://github.com/Own-Mailbox/sni2tor-proxy.git
cd sni2tor-proxy
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
