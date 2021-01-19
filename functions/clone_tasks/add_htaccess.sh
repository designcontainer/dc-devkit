add_htaccess() {
    if [ "$multisite" = true ] ; then
        echo "
# BEGIN WordPress
RewriteEngine On
RewriteCond %{REQUEST_URI} ^/wp-content/uploads/[^\/]*/.*$
RewriteRule ^(.*)$ http://$installname.wpengine.com/\$1 [QSA,L]
RewriteBase /
RewriteRule ^index\.php$ - [L]

# add a trailing slash to /wp-admin
RewriteRule ^wp-admin$ wp-admin/ [R=301,L]

RewriteCond %{REQUEST_FILENAME} -f [OR]
RewriteCond %{REQUEST_FILENAME} -d
RewriteRule ^ - [L]
RewriteRule ^(wp-(content|admin|includes).*) \$1 [L]
RewriteRule ^(.*\.php)$ \$1 [L]
RewriteRule . index.php [L]
# END WordPress
        " > .htaccess
    else
        echo "
# BEGIN WordPress

<IfModule mod_rewrite.c>
RewriteEngine On
RewriteCond %{REQUEST_URI} ^/wp-content/uploads/[^\/]*/.*$
RewriteRule ^(.*)$ http://$installname.wpengine.com/\$1 [QSA,L]
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>

# END WordPress
        " > .htaccess
    fi
}