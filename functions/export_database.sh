export_database() {
    # Vars
    mysqldump_path='/Applications/MAMP/Library/bin/mysqldump'
    conf=site_cloner.conf
    
    # Check if conf file exists
    if ! test -f "$conf" ; then
        echo -e "${error}Site cloner configuration file not found in this directory.${end}"
        exit 1
    fi
    
    source $conf
    
    clear
    
    DIR="$PWD/db-exports"
    if [ ! -d "$DIR" ]; then
        mkdir db-exports
    fi
    
    unixtime=$(date +%s)
    
    echo -e "
    ${warning}Exporting database: $sitename${end}"
    $mysqldump_path -u$sqluser -p$sqlpass $sitename > "$DIR/${sitename}_export_${unixtime}.sql"
    
    clear
    echo -e "
    ${success}✅ Exported: ${sitename}_export_${unixtime}.sql${end}"
    
    open -a "finder" -R "$DIR/${sitename}_export_${unixtime}.sql"
    
}