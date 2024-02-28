valet_driver="LocalValetDriver.php"

add_valet_local_driver() {
    # Check if the file already exists
    if [ ! -f "$valet_driver" ]; then
        # Create new valet driver file for the site
        touch "$valet_driver"

        echo "<?php

                include dirname(dirname(__FILE__)) . '/BaseLocalValetDriver.php';

                class LocalValetDriver extends BaseLocalValetDriver {

                    public \$remote_host = 'https://$installname.wpengine.com/';

                    /**
                    * This method checks if we have the file on disk. If not, changes the domain of any requests for files within the
                    * uploads directory to the remote domain. It also sets a flag that this request is now a remote request.
                    *
                    * @param string \$sitePath
                    * @param string \$siteName
                    * @param string \$uri
                    *
                    * @return bool|false|string
                    */
                    public function isStaticFile( \$sitePath, \$siteName, \$uri ) {
                        return parent::isStaticFile( \$sitePath, \$siteName, \$uri );
                    }

                }
" > "$valet_driver"
        # Call function to add LocalValetDriver.php to .gitignore
        add_to_gitignore "$valet_driver"
    else
        echo "File $valet_driver already exists."
    fi
}