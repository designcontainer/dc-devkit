fetch_database() {
# Vars
mysql_path='/Applications/MAMP/Library/bin/mysql'
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