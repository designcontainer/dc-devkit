setup() {

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

	if [ -n "$1" ] && [[ $1 == "--reset" ]]; then
		config_template
	fi

	greeting
	echo -e "
	${warning}Web Devkit setup wizard${end}${NL}You have to complete this setup wizard in order to use site cloner."


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


	while true; do
		read -p "Would you like to set a github account? (optional) [y/n]:" yn
		case $yn in
			[Yy]* )
				echo -e "${NL}Github Username:"
				read -e gitusername
				sed -i .old '/gitusername/ s/="[^"][^"]*"/="'${gitusername}'"/' $config

				echo -e "${NL}Github E-mail:"
				read -e gitemail
				sed -i .old '/gitemail/ s/="[^"][^"]*"/="'${gitemail}'"/' $config

				echo -e "${NL}Github SHH Config key:"
				read -e gitshhinput
				sed -i .old '/gitSSHId/ s/="[^"][^"]*"/="'${gitshhinput}'"/' $config
			break;;
			[Nn]* ) exit;;
			* ) echo "Please answer yes or no.";;
		esac
	done

	# Marks setup ad complete
	sed -i .old '/setup/ s/="[^"][^"]*"/="true"/' $config
	rm $config.old

	source $shell_profile_path
	echo -e "${NL}${success}✅ Site cloner setup completed!${end}"

	help

	# Resets terminal for dev alias to work.
	case $SHELL in
		/bin/bash)
			exec bash -l
		;;

		/bin/zsh)
			exec zsh -l
		;;
	esac

}
