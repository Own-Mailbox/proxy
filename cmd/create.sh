cmd_create_help() {
    cat <<_EOF
    create
        Create the container '$CONTAINER'.

_EOF
}

rename_function cmd_create orig_cmd_create
cmd_create() {
    orig_cmd_create \
        --mount type=bind,src=$(realpath $APP_DIR),dst=/opt/Own-Mailbox/proxy \
        --env APP_DIR=/opt/Own-Mailbox/proxy \
        --workdir /var/www \
        "$@"    # accept additional options, e.g.: -p 2201:22
}
