remove() {
    # Checks
    check_mysql_connection
    check_conf_exist
    check_confirmation_question "Are you sure you want to remove this site from your computer?(y/n)"
    
    # Remove Vhosts
    sed -i '' "/${PWD%/}\//.devkit\/vhosts.conf/d" $vhosts_conf
    
    # Remove the database
    $mysql_path -u$sqluser -p$sqlpass -e "DROP DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
    
    # Remove the dir
    rm -rf "${PWD%/}"
    
    clear
    echo -e "${success}✅ $sitename was successfully removed${end}"
    
    cd
}
