fetch_database() {
# Vars
mysql_path='/Applications/MAMP/Library/bin/mysql'
mysqldump_path='/Applications/MAMP/Library/bin/mysqldump'
conf=site_cloner.conf
if test -f "$conf"; then

source $conf

clear
echo -e "${error}
Are you sure you want to fetch a new database?
THIS WILL OVERWRITE ALL THE EXISTING DATA IN THE CURRENT LOCAL DATABASE!!
(y/n)
${end}"
read -e fetch_db

if [ "$fetch_db" == y ] ; then
clear
echo -e "${warning}
Fetching and importing a new database
This may take a minute ...
${end}"

# Get live database
rsync -e "ssh" $installname@$installname.ssh.wpengine.net:/sites/$installname/wp-content/mysql.sql $PWD >/dev/null 2>&1

if [ "$multisite" = true ] ; then
    # Drop old database
    $mysql_path -u$sqluser -p$sqlpass -e "DROP DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."

    # Create a new database
    $mysql_path -u$sqluser -p$sqlpass -e "CREATE DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."

    # Import database
    $mysql_path -u$sqluser -p$sqlpass $sitename < mysql.sql 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."

    # Delete Search WP tables if they exist, because they are causing conflicts on import
    drop_swp_statement=$($mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "
    SELECT CONCAT( 'DROP TABLE ', GROUP_CONCAT(table_name) , ';' ) 
        AS statement FROM information_schema.tables 
        WHERE table_schema = '$sitename' AND table_name LIKE '%_swp_%'" 2>/dev/null)
    $mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "$drop_swp_statement" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."

    # Fetch domains from database
    while IFS= read -r line; do
        domains+=("$line")
    done < <($mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "SELECT  domain FROM wp_blogs LIMIT 100;" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure.")

    # Create a new array and sort the domains
    while IFS= read -r line; do
        domains_sorted+=("$line")
    done < <(perl -w $scriptpath/functions/clone_tasks/sort_ms_domains.pl ${domains[@]})

    # Add index numbers to arrays in domains from conf file
    for i in "${!new_ms_domains[@]}"; do
        : #Do nothing
    done

    # Export the database again so we can modify it further
    rm mysql.sql
    $mysqldump_path -u$sqluser -p$sqlpass $sitename > mysql.sql 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."

    # Replace domains
    index=0
    for i in "${domains_sorted[@]}"; do
        sed -i '' -e "s/www.$i/${new_ms_domains[$index]}/g" mysql.sql
        sed -i '' -e "s/$i/${new_ms_domains[$index]}/g" mysql.sql

        # Increment index
        index=$((index+1))
    done

    # Replace https with http
    sed -i '' -e "s/https:\/\//http:\/\//g" mysql.sql
fi

# Drop old database
$mysql_path -u$sqluser -p$sqlpass -e "DROP DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."

# Create a new database
$mysql_path -u$sqluser -p$sqlpass -e "CREATE DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."

# Import database
$mysql_path -u$sqluser -p$sqlpass $sitename < mysql.sql 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."

rm mysql.sql

clear
echo -e "
${success}✅ New database imported${end}"
fi

else

echo -e "${error}
Site cloner configuration file not found in this directory.
${end}"

fi
}