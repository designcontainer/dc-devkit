debug_log() {
    check_conf_exist
    check_access_ssh
    echo -e "${warning}Enabling debugging...${end}"

    # Enable debugging, except display
    ssh -t hyttenett@hyttenett.ssh.wpengine.net `wp config set WP_DEBUG true --raw --anchor="# That's It. Pencils down" && wp config set WP_DEBUG_LOG true --raw --anchor="# That's It. Pencils down" && wp config set WP_DEBUG_DISPLAY false --raw --anchor="# That's It. Pencils down"`

    # Display a message to the user to visit site, maybe even get domains?
    if [ "$multisite" = true ] ; then
        echo "Select the site you want to open ..."
        select domain in "${main_ms_domains[@]}"
        do
            open http://$domain
        done
    else
        read -p "Devkit wants to open $installname.wpengine.com, press ENTER to continue ..."
        open http://$installname.wpengine.com
    fi

    # Wait for user to prompt ok done
    read -p "Press ENTER when you're done to extract the debug log"

    # Get the log
    ssh -t "$installname@$installname.ssh.wpengine.net" $(echo "cat sites/$installname/wp-content/debug.log");

    # Disable debugging
    ssh -t $installname@$installname.ssh.wpengine.net "wp config set WP_DEBUG false --raw --anchor=\"# That's It. Pencils down\" && wp config set WP_DEBUG_LOG false --raw --anchor=\"# That's It. Pencils down\" && wp config set WP_DEBUG_DISPLAY false --raw --anchor=\"# That's It. Pencils down\"" >/dev/null 2>&1

    # Delete the log files
    ssh -t $installname@$installname.ssh.wpengine.net "rm sites/$installname/wp-content/debug.log" >/dev/null 2>&1

}