help() {
    greeting
    
    echo -e "
Version:
    $version

Usage:
    ${prefix} [command]

Basic commands:
    ${cmd}-o, open${end}                            Opens site in browser from folder
    ${cmd}-w, wpe <page>${end}                      Open WP Engine panel for site. (-h, --help forargs)
    ${cmd}-t, test${end}                            Test if site is devkit ready
    ${cmd}github, gh${end}                          Open github site repo in browser

Development:
    ${cmd}new <site name>${end}                     Create a blank Wordpress install with DC skeleton theme
    ${cmd}clone <wpe install name>${end}            Clone a new site from WP Engine
    ${cmd}db, database <arg>${end}                  Fetch or export databases. (-h, --help forargs)
    ${cmd}remove${end}                              Remove site from computer. Includes files, vhosts and database
    ${cmd}ssh${end}                                 Connect to the installs SSH server
    ${cmd}debug${end}                               Get and output the debug.log on the server

Server:
    ${cmd}mamp${end}                                Restarts MAMP. (-h, --help forargs)
    ${cmd}hosts${end}                               Opens hosts file
    ${cmd}vhosts${end}                              Opens virtual hosts file
    ${cmd}phpmyadmin${end}                          Opens local phpmyadmin

WP Engine:
    ${cmd}backup <message>${end}                    Create a new backup on WP Engine
    ${cmd}cache${end}                               Purge cache for WP Engine install

Update:
    ${cmd}update${end}                              Updates site cloner to latest version

Configuration:
    ${cmd}setup${end}                               Re-runs the setup wizard. Flags: --reset (fixes corrupted conf file)
    "
}
