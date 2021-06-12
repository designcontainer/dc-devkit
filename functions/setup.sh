setup() {
    if [ -n "$1" ] && [[ $1 == "--reset" ]]; then
        config_template
    fi
    
    greeting
    echo -e "
    ${warning}Web Devkit setup wizard${end}${NL}You have to complete this setup wizard in order to use site cloner."
    
    # Adds an alias
    case $0 in
        
        -bash)
            shell_profile_path="/Users/$USER/.bash_profile"
        ;;
        
        -zsh)
            shell_profile_path="/Users/$USER/.bash_profile"
        ;;
        
        *)
            shell_profile_path="/Users/$USER/.bash_profile"
        ;;
    esac
    
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
    
    # Marks setup ad complete
    sed -i .old '/setup/ s/="[^"][^"]*"/="true"/' $config
    rm $config.old
    
    source $shell_profile_path
    echo -e "${NL}${success}✅ Site cloner setup completed!${end}"
    help
}
