help() {
    greeting
    
    echo -e "
Version:
    $version

Usage:
    ${prefix} [command]

Basic Commands:
    ${cmd}-o, open${end}                            Opens site in browser from folder
    ${cmd}new <site name>${end}                     Create a blank Wordpress install with DC skeleton theme
    ${cmd}clone <wpe install name>${end}            Clone a new site from WP Engine
    ${cmd}db, database <arg>${end}                  Fetch or export databases
    ${cmd}wpe <page>${end}                          Open WP Engine panel for site, <help, -h> to see args

Development:
    ${cmd}mamp${end}                                Restarts MAMP, <help, -h> to see args
    ${cmd}hosts${end}                               Opens hosts file
    ${cmd}vhosts${end}                              Opens virtual hosts file
    ${cmd}phpmyadmin${end}                          Opens local phpmyadmin

Update:
    ${cmd}update${end}                              Updates site cloner to latest version

Configuration:
    ${cmd}setup${end}                               Re-runs the setup wizard
    "
}