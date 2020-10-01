add_config_file() {
echo "installname=$installname
sitename=$sitename
new_ms_domains=(${new_ms_domains[@]})
" > site_cloner.conf

if [ "$multisite" = true ] ; then
echo "multisite=true
new_ms_domains=(${new_ms_domains[@]})
" >> site_cloner.conf
fi

# Add site_cloner.conf to gitignore if it does not exist
if [ !grep -R "site_cloner.conf" .gitignore ]; then
echo "
site_cloner.conf" >> .gitignore
fi
}