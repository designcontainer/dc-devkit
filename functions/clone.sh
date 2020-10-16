clone() {
    # Vars
    clone_tasks="$(dirname $0)/functions/clone_tasks"
    
    # Tasks
    for file in $clone_tasks/*.sh ; do
        if [ -f "$file" ] ; then
            . "$file"
        fi
    done
    
    # Check if can connect to mysql, exit if not
    check_mysql_connection
    
    clear
    
    if [ -n "$1" ]; then
        installname=$1
    else
        echo -e "${cmd}Enter the WP Engine install name to get started:${end}"
        read -e installname
    fi
    
    # Start some checks for choice of installname
    echo -e "${warning}Verifying permissions ...${NL}This will only take a couple of seconds.${end}"
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
        db_check=$($mysqlshow_path -u$sqluser -p$sqlpass "$sitename" > /dev/null 2>&1 && echo exists 2>&1)
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
    
    # Start cloning
    clear
    echo -e "${warning}${NL}Cloning install: $installname into $sitename ${NL}This may take a minute ...${end}"
    
    git_clone
    setup_database
    
    # Check if the site is a multisite and create variables
    if [ $($mysql_path -u$sqluser -p$sqlpass -D $sitename -h localhost -sse "SELECT count(*) FROM wp_blogs;" 2>/dev/null ) -gt 0 2>/dev/null ]; then
        multisite=true
    else
        multisite=false
    fi
    
    install_wpcore
    
    if [ "$multisite" = true ] ; then
        setup_multisite
    fi
    add_htaccess
    add_config_file
    git_commit
    
    if [ "$multisite" = false ] ; then
        # We set these in function setup_multisite if the site is a multisite
        add_vhost
        add_host
    fi
    
    # Restart MAMP Apache
    sudo /Applications/MAMP/Library/bin/apachectl -k restart >/dev/null 2>&1
    
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
    
    clear
    if [ "$multisite" = true ] ; then
        echo -e "${success}✅ Sites are setup and ready to use on the following domains: ${NL}$joined_domains${end}"
    else
        echo -e "${success}✅ http://$sitename.test is setup and ready to use!${end}"
    fi
    
}