setup_multisite() {
clear

echo -e "${warning}
It seems that this is a multisite.
This will require some extra configuration from your part.
${end}"

# Create an array with all domains in multisite
while IFS= read -r line; do
    domains+=("$line")
done < <($mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "SELECT  domain FROM wp_blogs LIMIT 100;" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure.")

for i in "${domains[@]}"; do

autodomain=${i%*.*}
autodomain=$(sed -e 's/www.//' <<<"$autodomain")

echo -e "${cmd}
Type in your desired local domain for domain: ${end}${success}$i${end}${cmd}
Press enter for suggested: $autodomain.test
${end}"

read -e mudomain

if [[ $mudomain == "" ]] ; then
mudomain="$autodomain.test"
fi

# Replace domains
sed -i '' -e "s/www.$i/$mudomain/g" mysql.sql
sed -i '' -e "s/$i/$mudomain/g" mysql.sql

# Add the new desired domains to an array, this will be used in the conf file
new_ms_domains+=("$mudomain")

# Add the first domain of array to var
if [ ! -n "$first_mudomain" ]; then
    first_mudomain=$mudomain
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
echo "127.0.0.1    $mudomain" | sudo tee -a /private/etc/hosts > /dev/null

done

# Replace https with http
sed -i '' -e "s/https:\/\//http:\/\//g" mysql.sql

# Reupload the database
# Drop old database
$mysql_path -u$sqluser -p$sqlpass -e "DROP DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
# Create a new database
$mysql_path -u$sqluser -p$sqlpass -e "CREATE DATABASE $sitename" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
# Import database
$mysql_path -u$sqluser -p$sqlpass $sitename < mysql.sql 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
# Delete file
rm mysql.sql

# Add the defines to get a multisite working in wp-config.php
NL=$'\\\n'
target="<?php"
ms_defines="<?php${NL}${NL}define( 'MULTISITE', true );${NL}define( 'SUBDOMAIN_INSTALL', true );${NL}define( 'DOMAIN_CURRENT_SITE', '$first_mudomain' );${NL}define( 'PATH_CURRENT_SITE', '\/' );${NL}define( 'SITE_ID_CURRENT_SITE', 1 );${NL}define( 'BLOG_ID_CURRENT_SITE', 1 );${NL}define( 'COOKIE_DOMAIN', \$_SERVER['HTTP_HOST'] );${NL}"

# sed -i '' -e "s~$target~i $ms_defines" wp-config.php
sed -i '' -e "s/$target/$ms_defines/" wp-config.php
}