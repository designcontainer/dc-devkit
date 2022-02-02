
![CLI Screenshot](https://user-images.githubusercontent.com/25268506/96168364-e88f2f00-0f20-11eb-9e65-931595dbe198.png)

# ✨ Web Devkit ✨

A CLI that helps you setup sites from WP Engine + some other nifty commands ❤️ 💯

## To get started (Simple setup):
1. If you have multiple githubs see github setps below first
2. Setup a SHH key on wpengine: https://wpengine.com/support/ssh-keys-for-shell-access/
3. Drag `start.sh` into your terminal
4. Follow setup wizard 😎 (leave "Github SHH Config key" empty)

After setup type `dev` to use. 🎉 🙌

### Multiple github accounts.
If you have a separate personal and a business github account on your computer, you have to use these settings.

1. Create a github SSH key in terminal:
`ssh-keygen -t rsa -b 4096 -f ~/.ssh/dc_github_rsa`
Leave password blank
Once the process has completed, run the following to print the contents of the new key file:
`cat .ssh/dc_github_rsa.pub`
Copy the ssh key and save it on Github

2. Create an SSH config file if you don't have one
https://wpengine.com/support/ssh-keys-for-shell-access/#SSH_Config_File

3. Add this code to the shh config, change the [your-github-username-here] to your github username
```
Host gh-[your-github-username-here]
	Hostname github.com
	User git
	IdentityFile ~/.ssh/dc_github_rsa
```

**Important:** *gh-[your-github-username-here]* is your "Github SHH Config key", remember it for the configuration later.

4. Follow the "Simple setup"-steps above!


## Error handling:
**"command not found: dev"**
If dev don't work, make sure your .bash_profile and .zshrc has this line:
`alias dev="bash path/to/start.sh"`

**"ERROR! Cannot connect to MYSQL server!"**
Remember to turn on Mamp Sql or your local Sql server.
