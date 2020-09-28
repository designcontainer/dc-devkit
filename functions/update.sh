update() {
if cd $scriptpath; git diff-index --quiet HEAD --; then
echo -e "${success}✅ DC Site Cloner is already up to date!${end}"
else
echo -e "${warning}Updating devkit ...${end}"
cd $scriptpath; git pull https://github.com/designcontainer/dc-site-cloner.git >/dev/null 2>&1
echo -e "${success}✅ DC Site Cloner updated!${end}
Version:
    $version
"
fi
}