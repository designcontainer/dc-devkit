update() {
    echo -e "${warning}Updating devkit ...${end}"
    cd $scriptpath; git pull https://github.com/designcontainer/dc-site-cloner.git >/dev/null 2>&1
    echo -e "${success}✅ DC Site Cloner updated!${end}"
    help
}