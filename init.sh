# Start the first process
service apache2 start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start apache: $status"
 exit $status
fi

# Start the second process
service mysql start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start mariadb: $status"
 exit $status
fi

# Start the second process
service bind9 start
status=$?
if [ $status -ne 0 ]; then
 echo "Failed to start bind9: $status"
 exit $status
fi

while /bin/true; do
 sleep 60
done
