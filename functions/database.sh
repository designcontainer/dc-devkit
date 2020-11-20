database() {
    check_conf_exist
    
    if [ "$1" == "-h" ] || [ "$1" == "help" ] ; then
        clear
        echo -e "
Usage:
	${prefix} db, database <arg>

Args:
	${cmd}help, -h${end}                            Shows all arguments

	${cmd}export${end}                              Fetch a new database from live server
	${cmd}fetch${end}                               Export your local database
        "
        
        elif [ "$1" == "export" ] ; then
        export_database
        
        elif [ "$1" == "fetch" ] ; then
        fetch_database
        
    else
        echo -e "${error}Arg not found${end}"
        database -h
    fi
}