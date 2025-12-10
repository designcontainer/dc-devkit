copy() {
    # Check if WP CLI is installed
    check_wp_cli_installed
    # Check if can connect to mysql, exit if not
    check_mysql_connection
    
    clear
    
    # Get source site name
    if [ -n "$1" ]; then
        sourcename=$1
    else
        echo -e "${cmd}Enter the source local site folder name to copy from:${end}"
        read -e sourcename
    fi
    
    # Check if source folder exists
    if [[ $sourcename == "" ]] ; then
        clear
        echo -e "${error}ERROR! No source site name provided.${end}"
        exit 1
    fi
    
    SOURCE_DIR="$PWD/$sourcename"
    if [ ! -d "$SOURCE_DIR" ]; then
        echo -e "${error}ERROR! Source folder '$sourcename' does not exist in current directory.${end}"
        exit 1
    fi
    
    # Check if source has wp-config.php (is a WordPress site)
    if [ ! -f "$SOURCE_DIR/wp-config.php" ]; then
        echo -e "${error}ERROR! Source folder does not appear to be a WordPress installation (no wp-config.php found).${end}"
        exit 1
    fi
    
    clear
    echo -e "${cmd}Enter the name for the new local site:${end}"
    read -e sitename
    
    # Checks for choice of sitename
    check_folder_exist() {
        if [[ $sitename == "" ]] ; then
            clear
            echo -e "${error}ERROR! No site name provided.${end}"
            exit 1
        fi
        DIR="$PWD/$sitename"
        if [ -d "$DIR" ]; then
            echo -e "${error}A folder with the specified site name already exists. ${NL}Please choose another site name:${end}"
            read -e sitename
            check_folder_exist
        fi
    }
    
    check_db_exist() {
        if [[ $sitename == "" ]] ; then
            clear
            exit 1
        fi
        
        if [ -z "$sqlpass" ]; then
            db_check=$($mysqlshow_path -u$sqluser "$sitename" > /dev/null 2>&1 && echo exists 2>&1)
        else
            db_check=$($mysqlshow_path -u$sqluser -p$sqlpass "$sitename" > /dev/null 2>&1 && echo exists 2>&1)
        fi
        
        if [[ $db_check == exists ]]; then
            echo -e "${error}Database already exists for this name.${NL}Please choose another site name:${end}"
            read -e sitename
            check_folder_exist
            check_db_exist
        fi
    }
    
    check_folder_exist
    check_db_exist
    
    # Get source database name from wp-config.php
    source_db=$(grep "define.*DB_NAME" "$SOURCE_DIR/wp-config.php" | sed "s/.*'\([^']*\)'.*/\1/" | head -1)
    
    if [[ $source_db == "" ]]; then
        echo -e "${error}ERROR! Could not determine source database name from wp-config.php${end}"
        exit 1
    fi
    
    clear
    echo -e "${warning}${NL}Copying site: $sourcename into $sitename ${NL}This may take a minute ...${end}"
    
    # Copy files
    echo -e "${warning}Copying files...${end}"
    cp -R "$SOURCE_DIR" "$PWD/$sitename"
    cd "$PWD/$sitename"
    
    # Remove .devkit folder if it exists (will create fresh one)
    if [ -d ".devkit" ]; then
        rm -rf .devkit
    fi
    
    # Export source database and import to new database
    echo -e "${warning}Copying database...${end}"
    
    if [ -z "$sqlpass" ]; then
        $mysqldump_path -u$sqluser "$source_db" > temp_copy.sql 2>/dev/null
        $mysql_path -u$sqluser -e "CREATE DATABASE \`$sitename\`" 2>/dev/null
        $mysql_path -u$sqluser -D "$sitename" < temp_copy.sql 2>/dev/null
    else
        $mysqldump_path -u$sqluser -p$sqlpass "$source_db" > temp_copy.sql 2>/dev/null
        $mysql_path -u$sqluser -p$sqlpass -e "CREATE DATABASE \`$sitename\`" 2>/dev/null
        $mysql_path -u$sqluser -p$sqlpass -D "$sitename" < temp_copy.sql 2>/dev/null
    fi
    
    rm temp_copy.sql
    
    # Update wp-config.php with new database name
    echo -e "${warning}Updating wp-config.php...${end}"
    sed -i '' "s/define([[:space:]]*'DB_NAME'[[:space:]]*,[[:space:]]*'[^']*'/define( 'DB_NAME', '$sitename'/" wp-config.php
    
    # Get source site URL and replace with new
    echo -e "${warning}Replacing URLs in database...${end}"
    siteurl=$(wp option get siteurl 2>/dev/null)
    siteurl_stripped=$(echo "$siteurl" | sed 's~http[s]*://~~g')
    
    # Replace URLs
    wp search-replace "https://$siteurl_stripped" "https://$sitename.test" --all-tables --precise --quiet > /dev/null 2>&1
    wp search-replace "http://$siteurl_stripped" "https://$sitename.test" --all-tables --precise --quiet > /dev/null 2>&1
    wp search-replace "$siteurl_stripped" "$sitename.test" --all-tables --precise --quiet > /dev/null 2>&1
    
    # Create .devkit config
    mkdir -p .devkit
    touch $devkit_conf
    echo "sourcename=$sourcename"    >> $devkit_conf
    echo "sitename=$sitename"        >> $devkit_conf
    echo "removable=true"            >> $devkit_conf
    echo "multisite=false"           >> $devkit_conf
    
    # Valet secure
    echo -e "${warning}Setting up Valet...${end}"
    valet secure $sitename
    
    clear
    echo -e "${success}✅ https://$sitename.test is setup and ready to use!${end}"
}

