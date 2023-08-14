remove() {
    # Checks
    check_mysql_connection
    check_conf_exist
    check_site_removable
    confirm_with_install_name "Are you sure you want to remove this site from your computer? type the install name to confirm: "

    
    # Remove Vhosts
    match="${PWD%/}/.devkit/vhosts.conf"
    
    sed -i '' "/${match//\//\\/}/d" $vhosts_path
    
    # Remove the database
    $mysql_path -u$sqluser -p$sqlpass -e "DROP DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
    
    # Remove the dir
    rm -rf "${PWD%/}"
    
    clear
    
    echo -e "${success}✅ $sitename was successfully removed${end}"
}
