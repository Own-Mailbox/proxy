# Start apache2
service apache2 start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start apache: $status"
 exit $status
fi

# Start mysql/mariadb (points to the same service on deb)
service mysql start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start mariadb: $status"
 exit $status
fi

# Start bind9
service bind9 start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start bind9: $status"
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

while /bin/true; do
 sleep 60
done
