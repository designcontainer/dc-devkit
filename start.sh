#!/bin/bash -e

# Meta
version="0.16.1"
prefix="dev"

# vars
scriptpath="$(dirname $0)"
siteconf="$(dirname $0)/site-config.tar.gz"
functions="$(dirname $0)/functions"
config="$scriptpath/config.conf"
mysql_path='/Applications/MAMP/Library/bin/mysql'
mysqldump_path='/Applications/MAMP/Library/bin/mysqldump'
mysqlshow_path='/Applications/MAMP/Library/bin/mysqlshow'
mysqladmin_path='/Applications/MAMP/Library/bin/mysqladmin'
vhosts_path='/Applications/MAMP/conf/apache/extra/httpd-vhosts.conf'

# Colors
error='\033[0;31m'
warning='\033[0;33m'
success='\033[0;32m'
cmd='\033[0;36m'
end='\033[0m'
greprc=$?

# Space
NL=$'\\n'

# Functions
for file in $functions/*.sh ; do
    if [ -f "$file" ] ; then
        . "$file"
    fi
done
for file in $functions/*/*.sh ; do
    if [ -f "$file" ] ; then
        . "$file"
    fi
done

# Check if config file has been created
if [ ! -f "$config" ]; then
    echo 'setup="false"' > $config
    echo 'sqluser="root"' >> $config
    echo 'sqlpass="root"' >> $config
    setup
fi

source $config

# Function call
if [ "$setup" == "false" ] || [ "$1" == "setup" ] ; then
    setup
    
    elif [ "$1" == "" ] || [ "$1" == "-h" ] || [ "$1" == "help" ] ; then
    help
    
    elif [ "$1" == "-v" ] || [ "$1" == "version" ] ; then
    version
    
    elif [ "$1" == "update" ] ; then
    update
    
    elif [ "$1" == "-o" ] || [ "$1" == "open" ] ; then
    open_site
    
    elif [ "$1" == "new" ] ; then
    new $2
    
    elif [ "$1" == "clone" ] ; then
    clone $2
    
    elif [ "$1" == "db" ] || [ "$1" == "database" ] ; then
    database $2
    
    elif [ "$1" == "-w" ] || [ "$1" == "wpe" ] ; then
    wpe $2
    
    elif [ "$1" == "-t" ] || [ "$1" == "test" ] ; then
    test_site
    
    elif [ "$1" == "mamp" ] ; then
    mamp $2
    
    elif [ "$1" == "hosts" ] ; then
    open /private/etc/hosts
    
    elif [ "$1" == "vhosts" ] ; then
    open /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
    
    elif [ "$1" == "phpmyadmin" ] ; then
    open http://localhost/phpmyadmin
    
    elif [ "$1" == "testfile" ] ; then
    testfile
    
else
    echo -e "${error}Command not found.${NL}${end}Try ${prefix} help"
    exit 1
fi

# Written by Rostislav Melkumyan 2020
