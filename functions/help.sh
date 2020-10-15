help() {
    greeting
    
    echo -e "
Version:
    $version

Usage:
    ${prefix} [command]

Basic Commands:
    ${cmd}new <site name>${end}                     Create a blank Wordpress install with DC skeleton theme
    ${cmd}clone <wpe install name>${end}            Clone a new site from WP Engine
    ${cmd}database${end}                            Fetch a new database form server for an existing local install
    ${cmd}database local${end}                      Export the current local database
    ${cmd}wpe <page>${end}                          Open WP Engine panel for site, <help, -h> to see args

Development:
    ${cmd}restart${end}                             Restarts MAMP
    ${cmd}start${end}                               Starts MAMP
    ${cmd}stop${end}                                Stops MAMP
    ${cmd}hosts${end}                               Opens hosts file
    ${cmd}vhosts${end}                              Opens virtual hosts file
    ${cmd}phpmyadmin${end}                          Opens local phpmyadmin

Update:
    ${cmd}update${end}                              Updates site cloner to latest version

Configuration:
    ${cmd}setup${end}                               Re-runs the setup wizard
    "
}