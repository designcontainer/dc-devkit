clone_valet() {
    # Vars
    clone_tasks="$(dirname $0)/functions/clone_tasks"
    
    for file in $clone_tasks/*.sh ; do
        if [ -f "$file" ] && [[ $(basename $file) != "add_host.sh" ]] && [[ $(basename $file) != "add_vhost.sh" ]] && [[ $(basename $file) != "add_vhost.sh" ]] ; then
            . "$file"
        fi
    done
    
    # Check if WP CLI is installed
    check_wp_cli_installed
    # Check if can connect to mysql, exit if not
    check_mysql_connection
    
    clear
    
    if [ -n "$1" ]; then
        installname=$1
    else
        echo -e "${cmd}Enter the WP Engine install name to get started:${end}"
        read -e installname
    fi

    # Set the github url
    set_git_url
    
    # Start some checks for choice of installname
    echo -e "${warning}Verifying permissions ...${NL}This will only take a couple of seconds.${end}"
    echo -e "${warning}If you get password prompt multiple times, most likely your mysql user has no password. It's reccomended to set it.${end}"
    check_access_ssh
    check_access_git
    check_empty_git_repo
    
    # Done doing checks for installname
    
    clear
    echo -e "${cmd}Enter you desired local install name ${NL}or press enter to use the same name as on WP Engine:
    ${end}"
    
    read -e sitename
    
    # Checks for choice of sitename
    check_folder_exist() {
        if [[ $sitename == "" ]] ; then
            sitename=$installname
        fi
        if [[ $sitename == "" ]] ; then
            clear
            exit 1
        fi
        DIR="$PWD/$sitename"
        if [ -d "$DIR" ]; then
            echo -e "${error}A folder with the specified site name is already in use. ${NL}Please choose another site name:${end}"
            read -e sitename
            check_folder_exist
        fi
    }
    
    check_db_exist() {
        if [[ $sitename == "" ]] ; then
            sitename=$installname
        fi
        if [[ $sitename == "" ]] ; then
            clear
            exit 1
        fi
        
        if [ -z "$sqlpass" ]; then
            db_check=$($mysqlshow_path -u$sqluser "$sitename" > /dev/null 2>&1 && echo exists 2>&1)
        else
            db_check=$($mysqlshow_path -u$sqluser -p$sqlpass "$sitename" > /dev/null 2>&1 && echo exists 2>&1)
        fi
        
        if [[ $db_check == exists ]]; then
            echo -e "${error}Database is already in use for this name.${NL}Please choose another local install name:${end}"
            read -e sitename
            check_folder_exist
            check_db_exist
        fi
    }
    
    check_vhosts_exist() {
        if [[ $sitename == "" ]] ; then
            sitename=$installname
        fi
        if [[ $sitename == "" ]] ; then
            clear
            exit 1
        fi
        if grep -qF "ServerName $sitename.test" $vhosts_path;then
            echo -e "${error}Virtual hosts domain is already in use for this name. ${NL}Please choose another local install name:${end}"
            read -e sitename
            check_folder_exist
            check_db_exist
            check_vhosts_exist
        fi
    }
    check_folder_exist
    check_db_exist
    check_vhosts_exist
    
    
    # Checks OK
    # Start cloning
    clear
    echo -e "${warning}${NL}Cloning install: $installname into $sitename ${NL}This may take a minute ...${end}"
    
    git_clone
    install_wpcore
    setup_database
    add_config_files
    add_valet_local_driver
    
    # Check if the site is a multisite and create variables
    if [ $($mysql_path -u$sqluser -p$sqlpass -D $sitename -h localhost -sse "SELECT count(*) FROM wp_blogs;" 2>/dev/null ) -gt 0 2>/dev/null ]; then
        multisite=true
        setup_multisite
    else
        multisite=false
        replace_urls
    fi
    
    # Add multisite data to config.
    # If site is not multisite, multisite will equal to false
    if [ "$multisite" = true ] ; then
        echo "multisite=true"                          >> $devkit_conf
        echo "main_ms_domain=$main_ms_domain"          >> $devkit_conf
        echo "new_ms_domains=(${new_ms_domains[@]})"   >> $devkit_conf
    else
        echo "multisite=false"                         >> $devkit_conf
    fi
    
    add_htaccess

    git_commit
    
    # if [ "$multisite" = false ] ; then
    #     # We set these in function setup_multisite if the site is a multisite
    #     add_vhost
    #     add_host
    # fi
    
    # Comma separated list of mu domains
    if [ "$multisite" = true ] ; then
        delim=""
        joined_domains=""
        for domain in "${new_ms_domains[@]}"; do
            domain="http://$domain"
            joined_domains="$joined_domains$delim$domain"
            delim="\n"
        done
    fi

    # valet secure if not multisite
    if [ "$multisite" = false ] ; then
        valet secure
    fi

    # valet secure all domains if multisite
    if [ "$multisite" = true ] ; then
        for domain in "${new_ms_domains[@]}"; do
            valet secure $domain
        done
    fi
    
    clear
    if [ "$multisite" = true ] ; then
        echo -e "${success}✅ Sites are setup and ready to use on the following domains: ${NL}$joined_domains${end}"
    else
        echo -e "${success}✅ http://$sitename.test is setup and ready to use!${end}"
    fi
    
}