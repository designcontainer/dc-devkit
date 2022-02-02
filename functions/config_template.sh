config_template() {
    echo 'setup="false"'         > $config
    echo 'sqluser="root"'       >> $config
    echo 'sqlpass="root"'       >> $config
    echo 'sqlhost="localhost"'  >> $config
	echo 'gitSSHId="false"'     >> $config
	echo 'gitusername="false"'  >> $config
	echo 'gitemail="false"'     >> $config
}
