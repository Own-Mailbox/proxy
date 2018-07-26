#!/bin/bash -x
### Client-Server Communication

echo "Configuring cs-com"

dir=/opt/Own-Mailbox/cs-com
rm -rf $dir
git clone https://github.com/Own-Mailbox/cs-com.git $dir
rm -rf /var/www/html/request-omb
mkdir -p /var/www/html/request-omb
cp -a $dir/server/* /var/www/html/request-omb/
chown www-data /var/www/html/request-omb/Create_Acounts/

### get $DBNAME, $DBUSER, $DBPASS
source /host/settings.sh

sed -i /var/www/html/request-omb/Create_Acounts/add-dovecot-user.sh \
    -e "s#proxy.omb.one#$FQDN#"

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
