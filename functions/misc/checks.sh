# Common checks

check_confirmation_question() {
    clear
    echo -e "${error}$1${end}"
    read -e question
    if [ ! "$question" == y ] ; then
        exit 1
    fi
}

confirm_with_install_name() {
    clear
    echo -e "${error}$1${end}"
    read -e question
    if [ ! "$question" == $installname ] ; then
        exit 1
    fi
}


check_mysql_connection() {
    $mysqladmin_path -h localhost -u$sqluser -p$sqlpass processlist > /dev/null 2>&1
    if [ $? -eq 1 ] ; then
        clear
        echo -e "${error}ERROR! Cannot connect to MYSQL server!${end}"
        exit 1
    fi
}

check_access_ssh() {
    # Exit if empty
    if [[ $installname == "" ]] ; then
        clear
        exit 1
    fi
    # Check if you have access to ssh
    ssh_status=$(ssh -oStrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 $installname@$installname.ssh.wpengine.net echo ok 2>&1)
    # Try again if SSH doesn't come back ok. This is used for first time connections
    if [[ ! $ssh_status == ok ]] ; then
        ssh_status=$(ssh -oStrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 $installname@$installname.ssh.wpengine.net echo ok 2>&1)
    fi
    if [[ ! $ssh_status == ok ]]; then
        clear
        echo -e "${error}ERROR! Cannot connect to WP Engine using the specified install name: $installname ${NL}Make sure the install exists and your SSH key is added to the server!${end}"
        exit 1
    fi
}

check_access_git() {
    # Check if you have access to git repo
    git-remote-url-reachable() {
        git ls-remote "$1" CHECK_GIT_REMOTE_URL_REACHABILITY >/dev/null 2>&1
    }
    ls
    if ! git-remote-url-reachable $giturl ; then
        clear
        echo -e "${error}ERROR! Cannot connect to a repo on $giturl using the specified site name: $installname ${NL}Make sure your SSH key is added to the repo!${end}"
        open "https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
        exit 1
    fi
}

check_empty_git_repo() {
    # Check if git repo is empty
    if ! git ls-remote --exit-code -h "$giturl" >/dev/null 2>&1 ; then
        clear
        echo -e "${error}ERROR! Git repository for $installname appears to be empty!${end}"
        exit 1
    fi
}

check_conf_exist() {
    # Check if config file exists nearby
    if [ -f "$devkit_conf" ]; then
        source "${PWD%/}/$devkit_conf"
        elif [ "$PWD" = / ]; then
        echo -e "${error}ERROR! Site cloner configuration file not found in this directory.${end}"
        exit 1
    else
        cd ..
        check_conf_exist
    fi
}

check_wp_cli_installed() {
    # Check if WP Cli is installed
    if ! type -P wp &>/dev/null; then
        echo -e "${error}ERROR! WP CLI not installed. Please install WP CLI before proceeding.${end}"
        exit 1
    fi
}

check_site_removable() {
    # Check if the site is removable
    if [ ! -n "$removable" ] || [ $removable == "false" ] ; then
        echo -e "${error}ERROR! Devkit cannot remove this site.${end}"
        exit 1
    fi
}