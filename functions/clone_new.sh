clone_new() {
# Vars
mysql_path='/Applications/MAMP/Library/bin/mysql'
vhosts_path='/Applications/MAMP/conf/apache/extra/httpd-vhosts.conf'
tasks="$(dirname $0)/functions/clone_tasks"

# Tasks
for file in $tasks/* ; do
if [ -f "$file" ] ; then
    . "$file"
fi
done

clear

if [ -n "$1" ]; then
installname=$1
else
echo -e "${warning}
Enter the WP Engine install name to get started:
${end}"
read -e installname
fi


ssh_status=$(ssh -oStrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 $installname@$installname.ssh.wpengine.net echo ok 2>&1)

if [[ $ssh_status == ok ]] ; then

clear 
echo -e "${warning}
Enter you desired local install name 
or press enter to use the same name as on WP Engine:
${end}"

read -e sitename

if [[ $sitename == "" ]] ; then
sitename=$installname
fi

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

clear
echo -e "${warning}
Cloning install: $installname
This may take a minute ...
${end}"

# Start cloning
git_clone
setup_database
install_wpcore

# Check if the site is a multisite
if [ $($mysql_path -u$sqluser -p$sqlpass -D $sitename -h localhost -sse "SELECT count(*) FROM wp_blogs;" 2>/dev/null ) -gt 0 2>/dev/null ]; then
    multisite=true
    setup_multisite
else
    multisite=false
fi

add_htaccess
add_config_file

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
item = "https://$item"
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
Make sure the install exists and your SSH key is added!
${end}"
fi
}