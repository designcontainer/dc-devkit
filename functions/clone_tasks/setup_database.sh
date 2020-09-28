setup_database() {
clear
# Create a new database
$mysql_path -u$sqluser -p$sqlpass -e "CREATE DATABASE $sitename";

# Get live database
scp $installname@$installname.ssh.wpengine.net:/sites/$installname/wp-content/mysql.sql $PWD

# Import database
$mysql_path -u$sqluser -p$sqlpass $sitename < mysql.sql;

rm mysql.sql
}