config_template() {
    echo 'setup="false"'         > $config
    echo 'sqluser="root"'       >> $config
    echo 'sqlpass="root"'       >> $config
    echo 'sqlhost="localhost"'  >> $config
}