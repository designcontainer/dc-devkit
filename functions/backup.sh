backup() {
    check_conf_exist
    file=.devkit-temp-backup-data.json
    
    if [ -n "$1" ]; then
        message="$@"
    else
        message="Devkit backup"
    fi
    
    echo -e "${warning}Calling WP Engine...${end}"
    # Get a complete list of all sites and put it in a temp json file
    all_sites=$(curl -s -X GET "https://api.wpengineapi.com/v1/installs?limit=1000" -u $wpeuser:$wpepass)
    echo $all_sites > $file
    # Find the install id by install name in the temp json file
    install_id=$( jq -r ".results[]  | select(.name == \"$installname\") | .id" sites.json )
    # Send request to WP Engine for backup
    curl -s -X POST "https://api.wpengineapi.com/v1/installs/$install_id/backups" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \"description\": \"$message\",  \"notification_emails\": [ \"$email\" ]}" -u $wpeuser:$wpepass
    # Remove temp file
    rm $file
    
    echo -e "${NL}${success}Backup requested!${end}"
}