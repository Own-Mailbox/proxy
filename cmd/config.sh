cmd_config_help() {
    cat <<_EOF
    config
        Run configuration scripts inside the container.

_EOF
}

cmd_config() {
    # run standard config scripts
    ds inject ubuntu-fixes.sh
    ds inject set_prompt.sh
    ds inject mariadb.sh
    #ds inject ssmtp.sh

    # run custom config scripts
    ds inject cfg/db.sh
    ds inject cfg/sni2torproxy.sh
    ds inject cfg/cs-com.sh
    ds inject cfg/apache2.sh
    ds inject cfg/postfix.sh
    ds inject cfg/bind9.sh

    # install and config extra things that help development
    if [[ $DEV == 'true' ]]; then
        ds inject phpmyadmin.sh
        ds exec apt -y install vim aptitude
    fi

    if [[ $FQDN != 'omb.example.org' ]]; then
        ds inject cfg/get-ssl-cert.sh
    fi
}
