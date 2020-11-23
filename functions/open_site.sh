open_site() {
    check_conf_exist
    open "http://$sitename.test"
    echo -e "${success}✅ $sitename opened in browser!${end}"
}