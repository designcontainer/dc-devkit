add_config_file() {
echo "installname=$installname
sitename=$sitename
" > site_cloner.conf

# Add site_cloner.conf to gitignore if it does not exist
if [ !grep -R "site_cloner.conf" .gitignore ]; then
    printf "\nsite_cloner.conf" >> .gitignore
fi
}