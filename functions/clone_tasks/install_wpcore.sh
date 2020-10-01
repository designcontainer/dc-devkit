install_wpcore() {
    # install fresh wp core
    curl -O https://wordpress.org/latest.tar.gz > /dev/null 2>&1
    tar -zxvf latest.tar.gz > /dev/null 2>&1
    cd wordpress
    rm -rf wp-content
    cp -rf . ..
    cd ..
    rm -R wordpress
    cp wp-config-sample.php wp-config.php
    perl -pi -e "s/database_name_here/$sitename/g" wp-config.php
    perl -pi -e "s/username_here/$sqluser/g" wp-config.php
    perl -pi -e "s/password_here/$sqlpass/g" wp-config.php

    # Define a siteurl if it's not a multisite
    if [ "$multisite" = false ] ; then
    echo "" >> wp-config.php
    echo "/** Change the site URL */" >> wp-config.php
    echo "define( 'WP_HOME', 'http://$sitename.test' );" >> wp-config.php
    echo "define( 'WP_SITEURL', 'http://$sitename.test' );" >> wp-config.php
    fi

    mkdir wp-content/uploads
    chmod 777 wp-content/uploads
    rm latest.tar.gz
    
    # Remove plugins folder and get them from ssh instead, cause vendor files are not in git sometimes
    cd wp-content
    rm -rf plugins
    rsync -e "ssh" -r $installname@$installname.ssh.wpengine.net:/sites/$installname/wp-content/plugins $PWD >/dev/null 2>&1
    cd ..

    # Add to commit
    git add --all >/dev/null 2>&1
    git commit -m "Automated commit from dc site cloner 🤖" >/dev/null 2>&1
}