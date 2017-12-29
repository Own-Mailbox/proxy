cmd_create_help() {
    cat <<_EOF
    create
        Create the container '$CONTAINER'.

_EOF
}

rename_function cmd_create orig_cmd_create
cmd_create() {
    orig_cmd_create \
        --cap-add ALL --privileged
        #--cap-add SYS_ADMIN --cap-add=NET_ADMIN
}
