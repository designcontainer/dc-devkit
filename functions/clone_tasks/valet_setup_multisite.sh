setup_multisite() {
    clear
    echo -e "${warning}It seems that this is a multisite. ${NL}This will require some extra configuration from your part.${end}"

    # Create an array with all domains in multisite
    while IFS= read -r line; do
        domains+=("$line")
    done < <($mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "SELECT  domain FROM wp_blogs LIMIT 100;" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure.")

    # Create a new array and sort the domains
    while IFS= read -r line; do
        domains_sorted+=("$line")
    done < <(perl -w $scriptpath/functions/clone_tasks/sort_ms_domains.pl ${domains[@]})

    # Start asking for domains
    # Start adding hosts
    # Start adding vhosts
    # Start replacing domains in sql file
    for domain in "${domains_sorted[@]}"; do

        # Remove www from domains
        domain=$(sed -e 's/www.//' <<<"$domain")

        # Set an auto domain
        autodomain="${domain%*.*}.test"

        echo -e "${cmd}${NL}Type in your desired local domain for domain: ${end}${success}$domain${end}${cmd}${NL}Use following structure: subdomain.yourtestdomain.test ${end}"
        read -e new_domain

        # Set domain to auto domain if no domain written
        # if [[ $new_domain == "" ]] ; then
        #     new_domain="$autodomain"
        # fi

        # Check if new_domain already exist
        check_vhosts_exist_ms() {
            if grep -qF "ServerName $new_domain" $vhosts_path; then
                echo -e "${error}A Virtual hosts domain is already set for this domain. ${NL}Please enter another local domain:${end}"
                read -e new_domain
                check_vhosts_exist_ms
            fi
        }
        check_vhosts_exist_ms

        # Replace domains
        wp search-replace "www.$domain" "$new_domain" --all-tables --precise --quiet > /dev/null 2>&1
        wp search-replace "$domain" "$new_domain" --all-tables --precise --quiet > /dev/null 2>&1

        # Add the new desired domains to an array, this will be used in the conf file
        new_ms_domains+=("$new_domain")

        # Add the first domain of array to var
        if [ ! -n "$first_new_domain" ]; then
            first_new_domain=$new_domain
        fi

        # Check if domain matches up with the first domain in array from database
        # This domain will be used as main domain in wp config
        if [[ $domain == $domains ]] || [[ "www.$domain" == $domains ]] ; then
            # Add the defines to get a multisite working in wp-config.php
            SNL=$'\\\n'
            target="<?php"
            ms_defines="<?php${SNL}${SNL}define( 'MULTISITE', true );${SNL}define( 'SUBDOMAIN_INSTALL', true );${SNL}define( 'DOMAIN_CURRENT_SITE', '$new_domain' );${SNL}define( 'PATH_CURRENT_SITE', '\/' );${SNL}define( 'SITE_ID_CURRENT_SITE', 1 );${SNL}define( 'BLOG_ID_CURRENT_SITE', 1 );${SNL}define( 'COOKIE_DOMAIN', \$_SERVER['HTTP_HOST'] );${SNL}"

            # sed -i '' -e "s~$target~i $ms_defines" wp-config.php
            sed -i '' -e "s/$target/$ms_defines/" wp-config.php

            # Add a variable so we know that this is the main domain
            main_ms_domain=$new_domain
        fi

        # run valet link for each domain
        valet link $new_domain
        

    done # Loop done

    # Replace https with http
    wp search-replace "https://" "http://" --all-tables --precise  > /dev/null
    echo "Include ${PWD}/${vhosts_conf}" >> $vhosts_path

}