cache() {
    check_conf_exist
    check_confirmation_question "Are you sure you want to prge cache?${NL}This action will purge all cache for this install!${NL}(y/n)"
    file=.devkit-temp-cache-data.json
    
    echo -e "${warning}Calling WP Engine...${end}"
    # Get a complete list of all sites and put it in a temp json file
    all_sites=$(curl -s -X GET "https://api.wpengineapi.com/v1/installs?limit=1000" -u $wpeuser:$wpepass)
    echo $all_sites > $file
    # Find the install id by install name in the temp json file
    install_id=$( jq -r ".results[]  | select(.name == \"$installname\") | .id" sites.json )
    # Send request to WP Engine for purge_cache
    curl -X POST "https://api.wpengineapi.com/v1/installs/$install_id/purge_cache" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \"type\": \"object\"}" -u $wpeuser:$wpepass
    # Remove temp file
    rm $file
    
    echo -e "${success}Cache purge requested!${end}"
}