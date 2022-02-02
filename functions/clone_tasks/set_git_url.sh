set_git_url() {
	wpegiturl="git@git.wpengine.com:production/$installname.git"
	ghgiturl="git@github.com:designcontainer/$installname.git"

	# Use custom githubSHH if exists
	if $gitSSHhost ; then
		ghgiturl="$gitSSHId:designcontainer/$installname"
	else
		ghgiturl="git@github.com:designcontainer/$installname.git"
	fi

	git-remote-url-reachable() {
		git ls-remote "$1" CHECK_GIT_REMOTE_URL_REACHABILITY >/dev/null 2>&1
	}
	if git-remote-url-reachable $ghgiturl ; then
		giturl=$ghgiturl
	else
		giturl=$wpegiturl
	fi
}
