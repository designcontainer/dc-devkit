fetch_database() {
    # Checks
    check_wp_cli_installed
    check_mysql_connection
    check_conf_exist
    check_confirmation_question "Are you sure you want to fetch a new database?${NL}THIS WILL OVERWRITE ALL THE EXISTING DATA IN THE CURRENT LOCAL DATABASE!!${NL}(y/n)"
    
    clear
    echo -e "${warning}Fetching and importing a new database${NL}This may take a minute ...${end}"
    
    # Get live database
    ssh -t $installname@$installname.ssh.wpengine.net "wp db export sites/$installname/mysql.sql" >/dev/null 2>&1
    rsync -e "ssh" $installname@$installname.ssh.wpengine.net:/sites/$installname/mysql.sql $PWD >/dev/null 2>&1
    ssh -t $installname@$installname.ssh.wpengine.net "rm sites/$installname/mysql.sql" >/dev/null 2>&1
    
    # Disable Passnado
    sed -i '' -e "s/'passnado_protect','1'/'passnado_protect','0'/g" mysql.sql
    
    
    # Drop old database
    $mysql_path -u$sqluser -p$sqlpass -e "DROP DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
    
    # Create a new database
    $mysql_path -u$sqluser -p$sqlpass -e "CREATE DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
    
    # Import database
    $mysql_path -u$sqluser -p$sqlpass -f -D $sitename < mysql.sql 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
    
    # Replace https with http
    wp search-replace "https://" "http://" --all-tables --precise --quiet > /dev/null 2>&1
    
    # Delete Search WP tables if they exist, because they are causing conflicts on import
    drop_swp_statement=$($mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "
    SELECT CONCAT( 'DROP TABLE ', GROUP_CONCAT(table_name) , ';' )
    AS statement FROM information_schema.tables
    WHERE table_schema = '$sitename' AND table_name LIKE '%_swp_%'" 2>/dev/null)
    $mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "$drop_swp_statement" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
    
    if [ "$multisite" = true ] ; then
        # Fetch domains from database
        while IFS= read -r line; do
            domains+=("$line")
        done < <($mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "SELECT  domain FROM wp_blogs LIMIT 100;" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure.")
        
        # Create a new array and sort the domains
        while IFS= read -r line; do
            domains_sorted+=("$line")
        done < <(perl -w $scriptpath/functions/clone_tasks/sort_ms_domains.pl ${domains[@]})
        
        # Add index numbers to arrays in domains from conf file
        for domain in "${!new_ms_domains[@]}"; do
            : #Do nothing
        done
        
        # Replace domains
        index=0
        for domain in "${domains_sorted[@]}"; do
            wp search-replace "www.$domain" "${new_ms_domains[$index]}" --all-tables --precise --quiet > /dev/null 2>&1
            wp search-replace "$domain" "${new_ms_domains[$index]}" --all-tables --precise --quiet > /dev/null 2>&1
            
            # Increment index
            index=$((index+1))
        done
    else
        # Replace domain when imported if the site is not a multisite.
        $mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "UPDATE wp_options SET option_value = 'http://$sitename.test' WHERE option_name = 'home' OR option_name = 'siteurl'" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
    fi
    
    rm mysql.sql
    
    clear
    echo -e "${success}✅ New database imported${end}"
    
}