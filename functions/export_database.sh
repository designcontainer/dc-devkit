export_database() {
    # Checks
    check_mysql_connection
    check_conf_exist
    
    clear
    
    DIR="$PWD/.devkit/db-exports"
    if [ ! -d "$DIR" ]; then
        mkdir db-exports
    fi
    
    unixtime=$(date +%s)
    
    echo -e "${warning}Exporting database: $sitename${end}"
    $mysqldump_path -u$sqluser -p$sqlpass $sitename > "$DIR/${sitename}_export_${unixtime}.sql" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
    
    clear
    echo -e "${success}✅ Exported: ${sitename}_export_${unixtime}.sql${end}"
    
    open -a "finder" -R "$DIR/${sitename}_export_${unixtime}.sql"
    
}