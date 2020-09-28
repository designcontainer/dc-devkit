setup_database() {
clear

# Create a new database
$mysql_path -u$sqluser -p$sqlpass -e "CREATE DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."

# Get live database
scp $installname@$installname.ssh.wpengine.net:/sites/$installname/wp-content/mysql.sql $PWD >/dev/null 2>&1

# Import database
$mysql_path -u$sqluser -p$sqlpass $sitename < mysql.sql 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."

rm mysql.sql
}