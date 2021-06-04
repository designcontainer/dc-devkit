backup() {
    check_conf_exist
    file=.devkit-temp-backup-data.json
    echo -e "${warning}Calling WP Engine...${end}"
    all_sites=$(curl -s -X GET "https://api.wpengineapi.com/v1/installs?limit=1000" -u $wpeuser:$wpepass)
    echo $all_sites > $file
    
    install_id=$( jq -r ".results[]  | select(.name == \"$installname\") | .id" sites.json )
    curl -s -X POST "https://api.wpengineapi.com/v1/installs/$install_id/backups" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \"description\": \"Devkit backup\",  \"notification_emails\": [ \"$email\" ]}" -u $wpeuser:$wpepass
    rm $file
    echo ""
    echo -e "${success}Backup requested!${end}"
}