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
echo -e "${warning}
Enter the WP Engine install name to get started:
${end}"

read -e installname

ssh_status=$(ssh -o BatchMode=yes -o ConnectTimeout=5 $installname@$installname.ssh.wpengine.net echo ok 2>&1)

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

check_if_exist() {
DIR="$PWD/$sitename"
if [ -d "$DIR" ]; then
echo -e "${error}
Site name is already in use. 
Please choose another one:
${end}"
read -e sitename
check_if_exist
fi
}
check_if_exist

# Start cloning
git_clone
install_wpcore
add_htaccess
add_host
add_vhost
setup_database

clear
echo -e "
${success}✅ $sitename.test is setup and ready to use!${end}"

else
echo -e "${error}
Cannot connect to WP Engine using the specified site name: $installname
Make sure the install exists and your SSH key is added!
${end}"
fi
}