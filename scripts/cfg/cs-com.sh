#!/bin/bash -x
### Client-Server Communication

cd /root/
git clone https://github.com/Own-Mailbox/cs-com.git
mkdir /var/www/html/request-omb
cp cs-com/server/* /var/www/html/request-omb/

### get $DBNAME, $DBUSER, $DBPASS
source /host/settings.sh

cat <<EOF > /var/www/html/request-omb/global_variables.php
<?php
\$db_user="$DBUSER";
\$db_passphrase="$DBPASS";
\$db_name="$DBNAME";
\$domain_post_fix=".$MASTER_DOMAIN";
\$table_tls_proxy="Association";
\$data_base_postfix="postfix";
\$table_postfix="transport";
\$postfix_tor_transportation_prefix="smtptor";
?>
EOF
