update() {
if cd $scriptpath; git diff-index --quiet HEAD --; then
echo -e "${warning}No new version of DC Site Cloner avaiable ...${end}"
else
echo -e "${warning}Updating devkit ...${end}"
cd $scriptpath; git pull https://github.com/designcontainer/dc-site-cloner.git >/dev/null 2>&1
echo -e "${success}✅ DC Site Cloner updated!${end}
Version:
    $version
"
fi
}