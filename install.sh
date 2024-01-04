#!/usr/bin/env bash
# Install script for the zpm(zsh package manager)

TRUE=0
FALSE=1

##
# Check if the package manager is installed
# @return <boolean> TRUE if installed, FALSE otherwise
##
function check_curl_installed() {
    if ! command -v curl &> /dev/null
    then
        return ${FALSE}
    fi
    return ${TRUE}
}

##
# Check if the package manager is installed
# @return <boolean> TRUE if installed, FALSE otherwise
##
function check_wget_installed() {
    if ! command -v wget &> /dev/null
    then
        return ${FALSE}
    fi
    return ${TRUE}
}

function check_zsh_installed() {
    if ! command -v zsh &> /dev/null
    then
        return ${FALSE}
    fi
    return ${TRUE}
}

##
# if zsh is not installed, exit
##
if ! check_zsh_installed; then
    echo "Please install zsh to continue"
    exit 1
fi

if check_curl_installed; then
    curl -sL https://raw.githubusercontent.com/zpm-zsh/install/master/installer.zsh | bash
elif check_wget_installed; then
    wget -qO - https://raw.githubusercontent.com/zpm-zsh/install/master/installer.zsh | bash
else
    echo "Please install curl or wget to continue"
    exit 1
fi
