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
