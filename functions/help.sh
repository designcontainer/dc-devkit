help() {
    greeting
    
    if cd $scriptpath; git diff-index --quiet HEAD --; then
        echo -e "${success}✅ DC Site Cloner is already up to date!${end}"
    else
        echo -e "${warning}⚠️  There is a new version of DC Site Cloner available!${end}"
        echo -e "    $ ${cmd}${prefix} update${end} to update."
    fi
    
    echo -e "
Version:
    $version

Usage:
    ${prefix} [command]

Basic Commands:
    ${cmd}new <wpe install name>${end}              Clone a new site from WP Engine
    ${cmd}database${end}                            Fetch a new database form server for an existing local install
    ${cmd}database local${end}                      Export the current local database
    ${cmd}wpe <page>${end}                          Open WP Engine panel for site, <help, -h> to see args

Development:
    ${cmd}restart${end}                             Restarts MAMP - not working
    ${cmd}start${end}                               Starts MAMP - not working
    ${cmd}stop${end}                                Stops MAMP - not working
    ${cmd}hosts${end}                               Opens hosts file
    ${cmd}vhosts${end}                              Opens virtual hosts file

Update:
    ${cmd}update${end}                              Updates site cloner to latest version

Configuration:
    ${cmd}setup${end}                               Re-runs the setup wizard
    "
}