setup() {
    greeting
    echo -e "
    ${warning}Web Devkit setup wizard${end}${NL}You have to complete this setup wizard in order to use site cloner."
    
    # Adds an alias
    bash_profile_path="/Users/$USER/.bash_profile"
    if ! grep -qF "alias $prefix" $bash_profile_path ; then
        printf "${NL}alias $prefix=\"bash $scriptpath/start.sh\"" >> $bash_profile_path
        source $bash_profile_path
    fi
    
    echo -e "SQL username:"
    read -e sqluserinput
    sed -i .old '/sqluser/ s/="[^"][^"]*"/="'${sqluserinput}'"/' $config
    
    echo -e "${NL}SQL password:"
    read -e sqlpassinput
    sed -i .old '/sqlpass/ s/="[^"][^"]*"/="'${sqlpassinput}'"/' $config
    
    # Marks setup ad complete
    sed -i .old '/setup/ s/="[^"][^"]*"/="true"/' $config
    rm $scriptpath/config.sh.old
    
    
    echo -e "${NL}${success}✅ Site cloner setup completed!${end}"
    help
}
