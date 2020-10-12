clone_new() {
# Vars
mysql_path='/Applications/MAMP/Library/bin/mysql'
mysqldump_path='/Applications/MAMP/Library/bin/mysqldump'
mysqlshow_path='/Applications/MAMP/Library/bin/mysqlshow'
mysqladmin_path='/Applications/MAMP/Library/bin/mysqladmin'
vhosts_path='/Applications/MAMP/conf/apache/extra/httpd-vhosts.conf'
tasks="$(dirname $0)/functions/clone_tasks"

# Tasks
for file in $tasks/*.sh ; do
if [ -f "$file" ] ; then
    . "$file"
fi
done

# Check if can connect to mysql, exit if not
$mysqladmin_path -h localhost -u$sqluser -p$sqlpass processlist > /dev/null 2>&1
if [ $? -eq 1 ] ; then

    clear
    echo -e "${error}MYSQL IS NOT RUNNING!${end}"
    exit
fi

clear

if [ -n "$1" ]; then
installname=$1
else
echo -e "${cmd}
Enter the WP Engine install name to get started:
${end}"
read -e installname
fi


echo -e "${warning}
Verifying permissions ...
This will only take a couple of seconds.
${end}"

# Check if you have access to ssh
ssh_status=$(ssh -oStrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 $installname@$installname.ssh.wpengine.net echo ok 2>&1)
# Try again if SSH doesn't come back ok. This is used for first time connections
if [[ $ssh_status != ok ]] ; then
    ssh_status=$(ssh -oStrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 $installname@$installname.ssh.wpengine.net echo ok 2>&1)
fi

# Check if you have access to git repo
git-remote-url-reachable() {
    git ls-remote "$1" CHECK_GIT_REMOTE_URL_REACHABILITY >/dev/null 2>&1
}
giturl="git@git.wpengine.com:production/$installname.git"

if [[ $ssh_status == ok ]] && git-remote-url-reachable $giturl ; then

clear 
echo -e "${cmd}
Enter you desired local install name 
or press enter to use the same name as on WP Engine:
${end}"

read -e sitename

if [[ $sitename == "" ]] ; then
sitename=$installname
fi

# Start some checks for choice of sitename
# Start some checks for choice of sitename
# Start some checks for choice of sitename
check_if_folder_exist() {
DIR="$PWD/$sitename"
if [ -d "$DIR" ]; then
echo -e "${error}
Site name is already in use. 
Please choose another one:
${end}"
read -e sitename
check_if_folder_exist
fi
}
check_if_folder_exist

check_if_db_exist() {
db_check=$($mysqlshow_path -u$sqluser -p$sqlpass "$sitename" > /dev/null 2>&1 && echo exists 2>&1)
if [[ $db_check == exists ]]; then
echo -e "${error}
Database is already in use for this name. 
Please choose another local install name:
${end}"
read -e sitename
check_if_db_exist
fi
}
check_if_db_exist

check_if_vhosts_exist() {
if grep -qF "ServerName $sitename.test" $vhosts_path;then
echo -e "${error}
Virtual hosts domain is already in use for this name. 
Please choose another local install name:
${end}"
read -e sitename
check_if_vhosts_exist
fi
}
check_if_vhosts_exist


# Start cloning
# Start cloning
# Start cloning
clear
echo -e "${warning}
Cloning install: $installname
This may take a minute ...
${end}"

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

# Comma separated list of mu domains
if [ "$multisite" = true ] ; then
delim=""
joined_domains=""
for item in "${new_ms_domains[@]}"; do
item="http://$item"
joined_domains="$joined_domains$delim$item"
delim="\n"
done
fi

clear
if [ "$multisite" = true ] ; then
echo -e "
${success}✅ Sites are setup and ready to use on the following domains:
$joined_domains
${end}"
else
echo -e "
${success}✅ http://$sitename.test is setup and ready to use!${end}"
fi

else
echo -e "${error}
Cannot connect to WP Engine using the specified site name: $installname
Make sure the install exists and your SSH key is added to both the server and install!
${end}"
fi
}