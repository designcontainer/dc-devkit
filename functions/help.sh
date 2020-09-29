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

Development:
    ${cmd}restart${end}                             Restarts MAMP - not working
    ${cmd}start${end}                               Starts MAMP - not working
    ${cmd}stop${end}                                Stops MAMP - not working
    ${cmd}hosts${end}                               Opens hosts file - not working
    ${cmd}vhosts${end}                              Opens virtual hosts file - not working
    
Update:
    ${cmd}update${end}                              Updates site cloner to latest version

Configuration:
    ${cmd}setup${end}                               Re-runs the setup wizard
"
}