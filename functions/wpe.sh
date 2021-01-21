wpe() {
    check_conf_exist
    
    if [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
        clear
        echo -e "
Usage:
    ${prefix} wpe <arg>(optional)

Args:
    ${cmd}help, -h${end}                            Shows all arguments

    ${cmd}domains${end}                             Open Domains page in WP Engine panel
    ${cmd}cdn${end}                                 Open CDN page in WP Engine panel
    ${cmd}redirects${end}                           Open Redirect rules page in WP Engine panel
    ${cmd}backup${end}                              Open Backup points page in WP Engine panel
    ${cmd}logs${end}                                Open Access logs page in WP Engine panel
    ${cmd}errors${end}                              Open Error logs page in WP Engine panel
    ${cmd}sftp${end}                                Open SFTP users page in WP Engine panel
    ${cmd}git${end}                                 Open GIT push page in WP Engine panel
    ${cmd}ssl${end}                                 Open SSL page in WP Engine panel
    ${cmd}util, utilities${end}                           Open Utilities page in WP Engine panel
    ${cmd}migrate${end}                             Open Site migration page in WP Engine panel
    ${cmd}phpmyadmin${end}                          Open Site phpmyadmin
        "
        
        elif [ "$1" == "domains" ] ; then
        open "https://my.wpengine.com/installs/$installname/domains"
        
        elif [ "$1" == "cdn" ] ; then
        open "https://my.wpengine.com/installs/$installname/cdn"
        
        elif [ "$1" == "redirects" ] ; then
        open "https://my.wpengine.com/installs/$installname/redirect_rules"
        
        elif [ "$1" == "backup" ] ; then
        open "https://my.wpengine.com/installs/$installname/backup_points"
        
        elif [ "$1" == "logs" ] ; then
        open "https://my.wpengine.com/installs/$installname/access_logs"
        
        elif [ "$1" == "errors" ] ; then
        open "https://my.wpengine.com/installs/$installname/error_logs"
        
        elif [ "$1" == "sftp" ] ; then
        open "https://my.wpengine.com/installs/$installname/sftp_users"
        
        elif [ "$1" == "git" ] ; then
        open "https://my.wpengine.com/installs/$installname/git_push"
        
        elif [ "$1" == "ssl" ] ; then
        open "https://my.wpengine.com/installs/$installname/ssl_certificates"
        
        elif [ "$1" == "util" ] || [ "$1" == "utilities" ] ; then
        open "https://my.wpengine.com/installs/$installname/utilities"
        
        elif [ "$1" == "migrate" ] ; then
        open "https://my.wpengine.com/installs/$installname/migrate-my-site"
        
        elif [ "$1" == "phpmyadmin" ] ; then
        open "https://my.wpengine.com/installs/$installname/phpmyadmin"
        
        elif [ "$1" == "" ] ; then
        open "https://my.wpengine.com/installs/$installname"
        
    else
        echo -e "${error}Arg not found${end}"
        wpe -h
    fi
}