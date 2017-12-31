#!/bin/bash

### load global variables
source /host/settings.sh

echo -e 'Content-type: text/html\n\n'

domain=$(echo $SERVER_NAME | grep -P '(?=^.{5,254}$)(^(?:(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)' )
[[ "$domain" == $FQDN ]] && exit

tor=$(mysql -s -D $DBNAME -e "SELECT torservice FROM Association WHERE hostname = '$SERVER_NAME'")
rm -f /tmp/res-wget-$domain
echo "$domain $tor"> /tmp/log-www
torsocks wget $tor$REQUEST_URI -O /tmp/res-wget-$domain >>/tmp/log-www 2>&1
cat /tmp/res-wget-$domain
