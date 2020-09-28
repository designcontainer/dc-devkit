help() {
greeting
echo -e "
Version:
    $version

Usage:
    ${prefix} [command]

Basic Commands:
    ${cmd}new${end}                                 Clone a new site from WP Engine

Development:
    ${cmd}restart${end}                             Restarts MAMP - not working
    ${cmd}start${end}                               Starts MAMP - not working
    ${cmd}stop${end}                                Stops MAMP - not working
    ${cmd}hosts${end}                               Opens hosts file - not working
    ${cmd}vhosts${end}                              Opens virtual hosts file - not working
    
Update:
    ${cmd}update${end}                              Updates site cloner to latest version - not working

Configuration:
    ${cmd}setup${end}                               Re-runs the setup wizard
"
}