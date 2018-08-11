#!/bin/bash

printf 'Content-type: text/html\n\n'

source /host/settings.sh

domain=$( echo $SERVER_NAME  | grep -P '(?=^.{5,254}$)(^(?:(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)' )
if [ "$domain" != "$FQDN" ]; then

tor=$(mysql --user=$DBUSER --password=$DBPASS --database=$DBNAME\
            --execute="SELECT torservice FROM Association WHERE hostname = '$SERVER_NAME';" );

tor=$(echo $tor | awk '{print $2}')

rm /tmp/res-wget-$domain
echo "$domain $tor"> /tmp/log-www
torsocks wget $tor$REQUEST_URI -O /tmp/res-wget-$domain >>/tmp/log-www 2>&1
cat /tmp/res-wget-$domain
else
cat /var/www/html/$REQUEST_URI
fi
