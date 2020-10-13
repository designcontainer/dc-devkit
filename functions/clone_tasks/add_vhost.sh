add_vhost() {
    echo '' >> $vhosts_path
    echo '<VirtualHost *:80>' >> $vhosts_path
    echo 'ServerName '$sitename'.test' >> $vhosts_path
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
}