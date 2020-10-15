mamp() {
    if [ "$1" == "-h" ] || [ "$1" == "help" ] ; then
        clear
        echo -e "
Usage:
    ${prefix} mamp <arg>

Args:
    ${cmd}help, -h${end}                            Shows all arguments

    ${cmd}start${end}                               Start MAMP
    ${cmd}stop${end}                                Stop MAMP
    ${cmd}restart${end}                             Restart MAMP
        "
        
        elif [ "$1" == "start" ] ; then
        echo -e "${warning}Starting MAMP ...${end}"
        sudo /Applications/MAMP/Library/bin/apachectl -k start >/dev/null 2>&1
        /Applications/MAMP/bin/startMysql.sh >/dev/null 2>&1
        echo -e "${success}✅ Done!${end}"
        
        elif [ "$1" == "stop" ] ; then
        echo -e "${warning}Stopping MAMP ...${end}"
        sudo /Applications/MAMP/Library/bin/apachectl -k stop >/dev/null 2>&1
        /Applications/MAMP/bin/stopMysql.sh >/dev/null 2>&1
        echo -e "${success}✅ Done!${end}"
        
        elif [ "$1" == "restart" ] || [ "$1" == "" ] ; then
        echo -e "${warning}Restarting MAMP ...${end}"
        sudo /Applications/MAMP/Library/bin/apachectl -k restart >/dev/null 2>&1
        /Applications/MAMP/bin/startMysql.sh >/dev/null 2>&1
        /Applications/MAMP/bin/stopMysql.sh >/dev/null 2>&1
        echo -e "${success}✅ Done!${end}"
        
    else
        echo -e "${error}Arg not found${end}"
        mamp -h
    fi
}