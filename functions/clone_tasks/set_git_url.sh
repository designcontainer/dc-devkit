set_git_url() {
    wpegiturl="git@git.wpengine.com:production/$installname.git"
    ghgiturl="git@github.com:designcontainer/$installname.git"
    git-remote-url-reachable() {
        git ls-remote "$1" CHECK_GIT_REMOTE_URL_REACHABILITY >/dev/null 2>&1
    }
    if git-remote-url-reachable $ghgiturl ; then
        giturl=$ghgiturl
    else
        giturl=$wpegiturl
    fi
}