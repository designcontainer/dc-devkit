add_to_gitignore() {
    local file="$1"
    local gitignore=".gitignore"

    # Check if the file is already in .gitignore
    if ! grep -q "$file" "$gitignore"; then
        echo "$file" >> "$gitignore"
        echo "Added $file to .gitignore"
    else
        echo "$file is already in .gitignore"
    fi
}
