connect_ssh() {
    check_conf_exist
    echo -e "${warning}Establishing SSH connection...${end}"
    ssh -t "$installname@$installname.ssh.wpengine.net" "cd sites/\"$installname\"; exec \$SHELL -l";
}
