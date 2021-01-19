replace_urls() {
    # Get current siteurl
    siteurl=$(wp option get siteurl)
    # Strip http and https from siteurl
    siteurl=`echo "$siteurl" | sed 's~http[s]*://~~g'`
    
    # Replace all occurences of current siteurl with test url
    wp search-replace "www.$siteurl" "$sitename.test" --all-tables --precise --quiet > /dev/null 2>&1
    wp search-replace "$siteurl" "$sitename.test" --all-tables --precise --quiet > /dev/null 2>&1
    # Replace all occurences of wpengine urls
    wp search-replace "$installname.wpengine.com" "$sitename.test" --all-tables --precise --quiet > /dev/null 2>&1
    
    # Replace https with http
    wp search-replace "https://" "http://" --all-tables --precise --quiet > /dev/null 2>&1
}