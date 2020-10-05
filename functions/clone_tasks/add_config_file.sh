add_config_file() {
echo "installname=$installname
sitename=$sitename
" > site_cloner.conf

if [ "$multisite" = true ] ; then
echo "multisite=true
new_ms_domains=(${new_ms_domains[@]})
" >> site_cloner.conf
else 
echo "multisite=false
" >> site_cloner.conf
fi

# Add site_cloner.conf to gitignore if it does not exist
if ! grep -q "site_cloner.conf" .gitignore; then
echo "" >> .gitignore
echo "site_cloner.conf" >> .gitignore
echo "db-exports/" >> .gitignore
fi
}