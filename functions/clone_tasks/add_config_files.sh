add_config_files() {
    mkdir .devkit
    
    # Create a config file for the site
    touch $devkit_conf
    echo "installname=$installname"    >> $devkit_conf
    echo "sitename=$sitename"          >> $devkit_conf
    echo "removable=true"              >> $devkit_conf
    
    
    # Create a vhosts file for the site
    touch $vhosts_conf
    
    # Add .devkit to gitignore if it does not exist
    if ! grep -q ".devkit/" .gitignore; then
        echo ""         >> .gitignore
        echo ".devkit/" >> .gitignore
    fi
}