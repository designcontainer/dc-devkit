setup() {
    greeting
    echo -e "
    ${warning}Site cloner setup wizard${end}${NL}You have to complete this setup wizard in order to use site cloner."
    
    echo -e "SQL username:"
    read -e sqluserinput
    sed -i .old '/sqluser/ s/="[^"][^"]*"/="'${sqluserinput}'"/' $config
    
    echo -e "${NL}SQL password:"
    read -e sqlpassinput
    sed -i .old '/sqlpass/ s/="[^"][^"]*"/="'${sqlpassinput}'"/' $config
    
    # Marks setup ad complete
    sed -i .old '/setup/ s/="[^"][^"]*"/="true"/' $config
    rm config.sh.old
    
    echo -e "${NL}${success}✅ Site cloner setup completed!${end}"
    help
}