cmd_create_help() {
    cat <<_EOF
    create
        Create the container '$CONTAINER'.

_EOF
}

rename_function cmd_create orig_cmd_create
cmd_create() {
    local app_dir=$(dirname $(realpath $APP_DIR))
    orig_cmd_create \
        --mount type=bind,src=$app_dir,dst=/opt/Own-Mailbox/proxy \
        --workdir /var/www \
        --env APP_DIR=/opt/Own-Mailbox/proxy \
        "$@"    # accept additional options, e.g.: -p 2201:22

        #--cap-add SYS_ADMIN --cap-add=NET_ADMIN \
        #--cap-add ALL --privileged \
}
