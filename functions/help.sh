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
    ${cmd}restart${end}                             Restarts MAMP
    ${cmd}start${end}                               Starts MAMP
    ${cmd}stop${end}                                Stops MAMP
    ${cmd}hosts${end}                               Opens hosts file
    ${cmd}vhosts${end}                              Opens virtual hosts file
    
Update:
    ${cmd}update${end}                              Updates site cloner to latest version

Configuration:
    ${cmd}setup${end}                               Re-runs the setup wizard
"
}