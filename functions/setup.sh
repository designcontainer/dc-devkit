setup() {
    if [ -n "$1" ] && [[ $1 == "--reset" ]]; then
        config_template
    fi
    
    greeting
    echo -e "
    ${warning}Web Devkit setup wizard${end}${NL}You have to complete this setup wizard in order to use site cloner."
    
    # Adds an alias
    case $SHELL in
        /bin/bash)
            shell_profile_path="/Users/$USER/.bash_profile"
        ;;
        
        /bin/zsh)
            shell_profile_path="/Users/$USER/.zshrc"
        ;;
    esac
    
    echo $shell_profile_path
    
    if ! grep -qF "alias $prefix" $shell_profile_path ; then
        printf "${NL}alias $prefix=\"bash $scriptpath/start.sh\"" >> $shell_profile_path
    fi
    
    echo -e "Your email:"
    read -e emailinput
    sed -i .old '/email/ s/="[^"][^"]*"/="'${emailinput}'"/' $config
    
    echo -e "SQL username:"
    read -e sqluserinput
    sed -i .old '/sqluser/ s/="[^"][^"]*"/="'${sqluserinput}'"/' $config
    
    echo -e "${NL}SQL password:"
    read -e sqlpassinput
    sed -i .old '/sqlpass/ s/="[^"][^"]*"/="'${sqlpassinput}'"/' $config
    
    echo -e "${NL}SQL host:"
    read -e sqlhostinput
    sed -i .old '/sqlhost/ s/="[^"][^"]*"/="'${sqlhostinput}'"/' $config
    
    echo -e "WP Engine API username:"
    read -e wpeuserinput
    sed -i .old '/wpeuser/ s/="[^"][^"]*"/="'${wpeuserinput}'"/' $config
    
    echo -e "${NL}WP Engine API password:"
    read -e wpepassinput
    sed -i .old '/wpepass/ s/="[^"][^"]*"/="'${wpepassinput}'"/' $config

    echo -e "${NL}Please provide the path to your MySQL and Mysqldump executables. If you are using MAMP, the default path is /Applications/MAMP/Library/bin/.${NL}If you are using a different setup, please provide the path to your MySQL and Mysqldump executables."
    echo -e "${NL}You can use the which command to find the path to your MySQL and Mysqldump executables.${NL}For example:${NL}which mysql${NL}which mysqldump${NL}which mysqlshow${NL}which mysqladmin"
    
    which mysql
    which mysqldump
    which mysqlshow
    which mysqladmin


    # ask for mysql path
    echo -e "${NL}MySQL path:"
    read -e mysql_path
    sed -i .old '/mysql_path/ s/="[^"][^"]*"/="'${mysql_path}'"/' $config

    # ask for mysqldump path
    echo -e "${NL}Mysqldump path:"
    read -e mysqldump_path
    sed -i .old '/mysqldump_path/ s/="[^"][^"]*"/="'${mysqldump_path}'"/' $config

    # ask for mysqlshow path
    echo -e "${NL}Mysqlshow path:"
    read -e mysqlshow_path
    sed -i .old '/mysqlshow_path/ s/="[^"][^"]*"/="'${mysqlshow_path}'"/' $config

    # ask for mysqladmin path
    echo -e "${NL}Mysqladmin path:"
    read -e mysqladmin_path
    sed -i .old '/mysqladmin_path/ s/="[^"][^"]*"/="'${mysqladmin_path}'"/' $config
    
    # Marks setup ad complete
    sed -i .old '/setup/ s/="[^"][^"]*"/="true"/' $config
    rm $config.old
    
    source $shell_profile_path
    echo -e "${NL}${success}✅ Site cloner setup completed!${end}"
    help
}
