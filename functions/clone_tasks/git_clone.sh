git_clone() {
	# Git url specified in check: check_access_git
	git clone $giturl $sitename >/dev/null 2>&1
	cd $sitename
	#git remote set-url origin $giturl

	# Use custom githubSHH if exists
	if $gitSSHhost ; then
		git config user.name $gitusername
		git config user.email $gitemail
	fi


}
