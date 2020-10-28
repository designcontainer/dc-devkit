replace_urls() {
    # Replace domain when imported if the site is not a multisite. Multisites gets this step done at another stage
    $mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "UPDATE wp_options SET option_value = 'http://$sitename.test' WHERE option_name = 'home' OR option_name = 'siteurl'" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
}