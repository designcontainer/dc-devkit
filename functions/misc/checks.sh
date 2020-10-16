# Common checks

check_confirmation_question() {
    clear
    echo -e "${error}$1${end}"
    read -e question
    if [ ! "$question" == y ] ; then
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
    giturl="git@git.wpengine.com:production/$installname.git"
    git-remote-url-reachable() {
        git ls-remote "$1" CHECK_GIT_REMOTE_URL_REACHABILITY >/dev/null 2>&1
    }
    if ! git-remote-url-reachable $giturl ; then
        clear
        echo -e "${error}ERROR! Cannot connect to a repo using the specified site name: $installname ${NL}Make sure your SSH key is added to the install!${end}"
        open "https://my.wpengine.com/installs/$installname/git_push"
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
    conf=site_cloner.conf
    if ! test -f "$conf" ; then
        echo -e "${error}ERROR! Site cloner configuration file not found in this directory.${end}"
        exit 1
    fi
    source $conf
}