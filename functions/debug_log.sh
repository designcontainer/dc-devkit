debug_log() {
    check_conf_exist
    echo -e "${warning}Establishing SSH connection...${end}"
    ssh -t "$installname@$installname.ssh.wpengine.net" $(echo "cat ~/sites/$installname/wp-content/debug.log");
}
