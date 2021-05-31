connect_ssh() {
    check_conf_exist
    ssh "$installname@$installname.ssh.wpengine.net"
}

