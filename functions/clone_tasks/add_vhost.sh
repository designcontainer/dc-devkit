add_vhost() {
    echo '<VirtualHost *:80>' >> $vhosts_conf
    echo '    ServerName '$sitename'.test' >> $vhosts_conf
    echo '    DocumentRoot "'$PWD'"' >> $vhosts_conf
    echo '    <Directory "'$PWD'">' >> $vhosts_conf
    echo '        Options FollowSymLinks' >> $vhosts_conf
    echo '        AllowOverride None' >> $vhosts_conf
    echo '    </Directory>' >> $vhosts_conf
    echo '    <Directory "'$PWD'">' >> $vhosts_conf
    echo '        Options Indexes FollowSymLinks MultiViews' >> $vhosts_conf
    echo '        AllowOverride All' >> $vhosts_conf
    echo '        Order allow,deny' >> $vhosts_conf
    echo '        allow from all' >> $vhosts_conf
    echo '    </Directory>' >> $vhosts_conf
    echo '</VirtualHost>' >> $vhosts_conf
    
    echo "Include ${PWD}/${vhosts_conf}" >> $vhosts_path
}