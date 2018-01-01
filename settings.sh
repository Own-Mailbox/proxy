APP=Own-Mailbox/proxy
IMAGE=ombproxy
CONTAINER=ombproxy
PORTS="80:80 443:443 53:53 6565:6565"

#This proxy will give subdomains of MASTER_DOMAIN
MASTER_DOMAIN=omb.one
FQDN=proxy.$MASTER_DOMAIN
EMAIL=contact@omb.example.org

DBNAME=proxy
DBUSER=proxy
DBPASS='cutAlfApel1TibMunyoss3'

DEV=true

# ### Gmail account for notifications (by ssmtp).
# ### Make sure to enable less-secure-apps:
# ### https://support.google.com/accounts/answer/6010255?hl=en
# GMAIL_ADDRESS=
# GMAIL_PASSWD=
