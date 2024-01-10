#!/bin/bash

##
# The script used in the .git_hooks/pre-push to check the tag name to be pushed is valid or not before push to the remote repository.
# Usage: ./check_release_version.sh <tag name>
# e.g. ./check_release_version.sh 0.0.1
# @auther: wuchuheng<root@wuchuheng.com>
# @date: 2024-01-10 20:07
##


version=$1

red="\033[31m"
noColor="\033[0m"

error_msg() {
    local msg=$1
    echo "${red}${msg}${noColor}" > /dev/stderr
    exit 1;
}

# check the version must be not empty.
if [[ -z $version ]]
then
    error_msg "Version name must not be empty"
fi

##
# check the tag name in the file provide was existed or not
# @use check_tag_name_exists <tag name> <file path>
##
function check_tag_name_exists() {
    local tagName=$1;
    local filePath=$2;
    local isTagNameExists=$( cat "${filePath}" | grep "${tagName}");
    if [[ -z ${isTagNameExists} ]]; then
	error_msg "The tag name: ${tagName} was not existed in ${filePath}";
    fi
}

##
# check the tag name in CHANGELOG.md
# @use check_tag_name_in_changelog_me <tag name>
##
function check_tag_name_in_changelog_me() {
    local tag_name=$1
    # get the CHANGELOG.md from curreng tag name.
    # Navigate to the root of the repository
    REPO_ROOT=$(git rev-parse --show-toplevel)
    cd "$REPO_ROOT"

    # Get the contents of the CHANGELOG.md at the given tag
    CHANGELOG_CONTENT=$(git show "$tag_name:CHANGELOG.md")
    CHANGELOG_CONTENT=$(cat CHANGELOG.md)
    lastTagNameInChangeLog=$( 
        echo "${CHANGELOG_CONTENT}" \
        | grep -E '^## +\[(\d+\.\d+\.\d+)\]' \
        | head -n 1 \
        | sed -E 's/^## +\[([0-9]+\.[0-9]+\.[0-9]+)\].*/\1/'
    )
    echo "Check the tag name: ${tag_name}."

    # Check if the CHANGELOG.md has the change log for tag name
    if ! [[ "${tag_name}" == "${lastTagNameInChangeLog}" ]]; then
             error_msg "Tag name $tag_name was not existed in CHANGELOG.md', please to add the change log for the tag name ${tag_name} in CHANGELOG.md. for example:
## [${tag_name}] - 2021-01-01
- feat: add some features for ${tag_name}
- fix: fix some issue for ${tag_name}
- chore: something unimportan.
"
    # error_msg ${msg}
        fi
}

##
# Check the tag name is valid 
# @use check_tag_name_valid <tag name>
##
function check_tag_name_valid() {
    local tag_name=$1
    # Check if tag name fits the pattern
    if ! [[ $tag_name =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
    then
        error_msg "Tag name $tag_name does not match the pattern 'X.Y.Z'"
    fi
}

function check_tag_name_in_install_sh() {
    local tagName=$1
    local tagNameInInstallSh=$(cat install.sh | grep VERSION_NAME= | sed  -E 's/VERSION_NAME="(.*)"/\1/')
    if ! [[ "${tagName}" == "${tagNameInInstallSh}" ]]; then
        error_msg "Tag name $tag_name was not existed in install.sh', please to add the tag name ${tag_name} in install.sh."
    fi
}


check_tag_name_valid "${version}"
check_tag_name_in_changelog_me "${version}"
check_tag_name_in_install_sh "${version}"