#!/bin/bash -e

# Meta
version="0.1.2"
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

# Functions
for file in $functions/* ; do
  if [ -f "$file" ] ; then
    . "$file"
  fi
done

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

elif [ "$1" == "new" ]
then
clone_new

else
echo -e "
${error}Command not found.
    ${end} Try ${prefix} help
"
exit 1
fi

# Written by Rostislav Melkumyan 2020
