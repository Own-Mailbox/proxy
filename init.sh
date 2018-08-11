# Start apache2
service apache2 start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start apache: $status"
 exit $status
fi

# Start bind9
service bind9 start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start bind9: $status"
 exit $status
fi

# Make sure certificate is issued
# If we don't force the answer No, the container crashes
# as it is waiting forever for a response to the certbot
# survey question
no | ./get-ssl-cert.sh
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to issue cert: $status"
 exit $status
fi

# Start mysql/mariadb (points to the same service on deb)
service mysql start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start mariadb: $status"
 exit $status
fi

# Start dovecot service
service dovecot start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start dovecot: $status"
 exit $status
fi

# Start postfix
service postfix start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start postfix: $status"
 exit $status
fi

# Start rsyslog
service rsyslog start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start rsyslog: $status"
 exit $status
fi

# Start cron
service cron start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start cron: $status"
 exit $status
fi

# Start tor
service tor start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start tor: $status"
 exit $status
fi

# Start sni2torproxy
./etc/rc.local
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start sni2torproxy: $status"
 exit $status
fi

while /bin/true; do
 sleep 60
done
