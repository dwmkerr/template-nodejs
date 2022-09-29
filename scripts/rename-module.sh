#!/usr/bin/env bash

# Fail on errors and errors in pipelines.
set -e
set -o pipefail

# This script will rename the module from 'template-nodejs-module'.

# Variables we may want to quickly change in the future.
template_github_username="dwmkerr"
template_project_name="template-nodejs-module"
template_npm_package_name="@${template_github_username}/${template_project_name}"
template_github_repo="https://github.com/${template_github_username}/${template_project_name}"

# If the user has not provided GITHUB_USERNAME, get it now.
if [ -z "$GITHUB_USERNAME" ]; then
    read -p "Enter GitHub username: " github_username
else 
    echo "GitHub username provided by \$GITHUB_USERNAME: $GITHUB_USERNAME"
    github_username="${GITHUB_USERNAME}"
fi

# If the user has not provided PROJECT_NAME, get it now.
if [ -z "$PROJECT_NAME" ]; then
    read -p "Enter new module name: " project_name
else 
    echo "Module name provided by \$PROJECT_NAME: $PROJECT_NAME"
    project_name="${PROJECT_NAME}"
fi

# Log configuration to the user.
echo "Preparing to rename from: ${template_github_username}/${template_project_name}"
echo "                      to: ${github_username}/${project_name}"
github_repo="https://github.com/${github_username}/${project_name}"

# If the module appears to already have been renamed, abort.
package_json_name=$(cat ./package.json | grep '"name":' | cut -d'"' -f4)
echo "Current package name is: ${package_json_name}..."

if [[ "${package_json_name}" != "${template_npm_package_name}" ]]; then
    echo "'package.json' appears to have been modified from the original template,"
    echo "aborting rename now. Please reset any changes and try again."
fi

# Update the 'index.js' file.
cp ./index.js ./index.js.old
sed -e "s/${template_project_name}/${project_name}/" \
    ./index.js.old > ./index.js
rm index.js.old

function update_key_value_expr() {
    key=$1
    old_value=$2
    new_value=$3
    src_expr="\"${key}\":[[:space:]]*\"${old_value}\""
    replace_expr="\"${key}\": \"${new_value}\""
    echo "s%${src_expr}%${replace_expr}%"
}

# Update the package.json file.
# Note that these replacements are dependent on the package.json file not being
# edited from the template version and are very brittle.
cp ./package.json ./package.json.old
sed -e "$(update_key_value_expr "name" "${template_npm_package_name}" "${github_username}/${project_name}")" \
    -e "$(update_key_value_expr "url" "git\+${template_github_repo}\.git" "git\+${github_repo}\.git")" \
    -e "$(update_key_value_expr "url" "${template_github_repo}/issues" "${github_repo}/issues")" \
    -e "$(update_key_value_expr "homepage" "${template_github_repo}#readme" "${github_repo}#readme")" \
    -e "$(update_key_value_expr "author" "Dave Kerr" "")" \
    -e "s%DEBUG=${template_project_name}%DEBUG=${project_name}%g" \
    ./package.json.old > ./package.json
rm package.json.old

# Update the README file.
cp ./README.md ./README.md.old
sed -e "s/# ${template_project_name}/# ${project_name}/" \
    -e "s%${template_github_username}/${template_project_name}%${github_username}/${project_name}%g" \
    -e "s%DEBUG=${template_project_name}%DEBUG=${project_name}%g" \
    -e "s%'${template_project_name}'%'${project_name}'%g" \
    ./README.md.old > ./README.md
rm README.md.old

echo "Rename completed successfully."
