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

    # Export the database again so we can modify it further
    $mysqldump_path -u$sqluser -p$sqlpass $sitename > mysql.sql 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."

    # Start asking for domains
    # Start adding hosts
    # Start adding vhosts
    # Start replacing domains in sql file
    for i in "${domains_sorted[@]}"; do

        # Remove www from domains
        i=$(sed -e 's/www.//' <<<"$i")

        # Set an auto domain
        autodomain=${i%*.*}

        echo -e "${cmd}${NL}Type in your desired local domain for domain: ${end}${success}$i${end}${cmd}${NL}Press enter for suggested: $autodomain.test${end}"
        read -e mudomain

        # Set domain to auto domain if no domain written
        if [[ $mudomain == "" ]] ; then
            mudomain="$autodomain.test"
        fi

        check_vhosts_exist

        # Replace domains
        sed -i '' -e "s/www.$i/$mudomain/g" mysql.sql
        sed -i '' -e "s/$i/$mudomain/g" mysql.sql

        # Add the new desired domains to an array, this will be used in the conf file
        new_ms_domains+=("$mudomain")

        # Add the first domain of array to var
        if [ ! -n "$first_mudomain" ]; then
            first_mudomain=$mudomain
        fi

        # Check if domain matches up with the first domain in array from database
        # This domain will be used as main domain in wp config
        if [[ $i == $domains ]] || [[ "www.$i" == $domains ]] ; then
            # Add the defines to get a multisite working in wp-config.php
            SNL=$'\\\n'
            target="<?php"
            ms_defines="<?php${SNL}${SNL}define( 'MULTISITE', true );${SNL}define( 'SUBDOMAIN_INSTALL', true );${SNL}define( 'DOMAIN_CURRENT_SITE', '$mudomain' );${SNL}define( 'PATH_CURRENT_SITE', '\/' );${SNL}define( 'SITE_ID_CURRENT_SITE', 1 );${SNL}define( 'BLOG_ID_CURRENT_SITE', 1 );${SNL}define( 'COOKIE_DOMAIN', \$_SERVER['HTTP_HOST'] );${SNL}"

            # sed -i '' -e "s~$target~i $ms_defines" wp-config.php
            sed -i '' -e "s/$target/$ms_defines/" wp-config.php

            # Add a variable so we know that this is the main domain
            main_ms_domain=$mudomain
        fi

        # Add vhost
        echo '' >> $vhosts_path
        echo '<VirtualHost *:80>' >> $vhosts_path
        echo 'ServerName '$mudomain >> $vhosts_path
        echo 'DocumentRoot "'$PWD'"' >> $vhosts_path
        echo '    <Directory "'$PWD'">' >> $vhosts_path
        echo '        Options FollowSymLinks' >> $vhosts_path
        echo '        AllowOverride None' >> $vhosts_path
        echo '    </Directory>' >> $vhosts_path
        echo '    <Directory "'$PWD'">' >> $vhosts_path
        echo '        Options Indexes FollowSymLinks MultiViews' >> $vhosts_path
        echo '        AllowOverride All' >> $vhosts_path
        echo '        Order allow,deny' >> $vhosts_path
        echo '        allow from all' >> $vhosts_path
        echo '    </Directory>' >> $vhosts_path
        echo '</VirtualHost>' >> $vhosts_path

        # Add desired domain to hosts
        # Message for password promt, will show on first domain only
        if [ ! -n "$hostspw" ]; then
            echo -e "${warning}${NL}Password needed to modify the hosts file${end}"
            hostspw=true
        fi
        echo "127.0.0.1    $mudomain" | sudo tee -a /private/etc/hosts > /dev/null

    done # Loop done

    # Drop existing database
    $mysql_path -u$sqluser -p$sqlpass -e "DROP DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."

    # Create a new database
    $mysql_path -u$sqluser -p$sqlpass -e "CREATE DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."

    # Import edited database
    $mysql_path -u$sqluser -p$sqlpass $sitename < mysql.sql 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
    # Delete the sql file from site folder
    rm mysql.sql

}