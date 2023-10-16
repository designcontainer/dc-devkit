setup_database() {
    # Get live database
    ssh -t $installname@$installname.ssh.wpengine.net "wp db export sites/$installname/mysql.sql" >/dev/null 2>&1
    rsync -e "ssh" $installname@$installname.ssh.wpengine.net:/sites/$installname/mysql.sql $PWD >/dev/null 2>&1
    ssh -t $installname@$installname.ssh.wpengine.net "rm sites/$installname/mysql.sql" >/dev/null 2>&1
    
    # Disable Passnado
    sed -i '' -e "s/'passnado_protect','1'/'passnado_protect','0'/g" mysql.sql
    
    # Create a new database
    $mysql_path -u$sqluser -p$sqlpass -e "CREATE DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
    
    # Import database
    $mysql_path -u$sqluser -p$sqlpass -f -D $sitename < mysql.sql 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
    
    # Delete Search WP tables if they exist, because they are causing conflicts on import
    drop_swp_statement=$($mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "
SELECT CONCAT( 'DROP TABLE ', GROUP_CONCAT(table_name) , ';' )
    AS statement FROM information_schema.tables
    WHERE table_schema = '$sitename' AND table_name LIKE '%_swp_%'" 2>/dev/null)
    $mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "$drop_swp_statement" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
    
    # Delete the sql file from site folder
    rm *.sql
    find . -name "*.sql" -type f -delete
}
