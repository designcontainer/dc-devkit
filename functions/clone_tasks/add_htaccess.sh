add_htaccess() {
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
}