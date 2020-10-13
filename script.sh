#!/bin/bash -e

# Meta
version="0.6.1"
prefix="clone"

# Script
scriptpath="$(dirname $0)"
siteconf="$(dirname $0)/site-config.tar.gz"
functions="$(dirname $0)/functions"
config="$scriptpath/config.sh"
source $config

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
for file in $functions/* ; do
    if [ -f "$file" ] ; then
        . "$file"
    fi
done

# Check if config file has been created
if [ ! -f "$config" ]; then
    echo '#!/usr/bin/env bash
setup="false"

# database
sqluser="root"
sqlpass="root"
    ' > $config
    setup
fi

# Function call
if [ "$setup" == "false" ] || [ "$1" == "setup" ]
then
    setup
    
elif [ "$1" == "" ] || [ "$1" == "-h" ] || [ "$1" == "help" ]
then
    help
    
elif [ "$1" == "-v" ] || [ "$1" == "version" ]
then
    version
    
elif [ "$1" == "update" ]
then
    update
    
elif [ "$1" == "new" ]
then
    clone_new $2
    
elif [ "$1" == "database" ]
then
    if [ "$2" == "local" ]
    then
        export_database
    else
        fetch_database
    fi
    
elif [ "$1" == "hosts" ]
then
    open /private/etc/hosts
    
elif [ "$1" == "vhosts" ]
then
    open /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
    
elif [ "$1" == "testfile" ]
then
    testfile
    
else
    echo -e "${error}Command not found.${NL}${end} Try ${prefix} help"
    exit 1
fi

# Written by Rostislav Melkumyan 2020
