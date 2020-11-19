open_site() {
    check_conf_exist
    open "$sitename.test"
    echo -e "${success}✅ $sitename opened in browser!${end}"
}