config_template() {
    echo 'setup="false"'                                                 > $config
    echo 'email="youremail@yourdomain.com"'                             >> $config
    echo 'sqluser="root"'                                               >> $config
    echo 'sqlpass="root"'                                               >> $config
    echo 'sqlhost="localhost"'                                          >> $config
    echo 'wpeuser="wpeuser"'                                            >> $config
    echo 'wpepass="wpepass"'                                            >> $config
    echo 'mysql_path="/Applications/MAMP/Library/bin/mysql"'            >> $config
    echo 'mysqldump_path="/Applications/MAMP/Library/bin/mysqldump"'    >> $config
    echo 'mysqlshow_path="/Applications/MAMP/Library/bin/mysqlshow"'    >> $config
    echo 'mysqladmin_path="/Applications/MAMP/Library/bin/mysqladmin"'  >> $config
}