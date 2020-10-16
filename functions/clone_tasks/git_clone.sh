git_clone() {
    # Git url specified in check: check_access_git
    git clone $giturl $sitename >/dev/null 2>&1
}