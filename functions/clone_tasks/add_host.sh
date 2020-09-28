add_host() {
clear
echo -e "${warning}
Password needed to modify the hosts file
Please enter your password:
${end}"
echo '127.0.0.1    '$sitename'.test' | sudo tee -a /private/etc/hosts > /dev/null
}