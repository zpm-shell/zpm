#!/usr/bin/env zsh

TRUE=0
FALSE=1

##
# Check if zsh is installed
# @returnm {boolean} true if zsh is installed
##
function check_zsh_exists() {
    if [[ -z $(command -v zsh) ]]; then
        return ${FALSE}
    fi
    return ${TRUE}
}

##
# Check if zpm is installed
# @returnm {boolean} true if zpm is installed
##
function check_zpm_exists() {
    if [[ -z $(command -v zpm) ]]; then
        return ${FALSE}
    fi
    return ${TRUE}
}

##
# Check if git is installed
# @returnm {boolean} true if git is installed
##
function check_git_exists() {
    if [[ -z $(command -v git) ]]; then
        return ${FALSE}
    fi
    return ${TRUE}
}

##
# Check if curl is installed
# @returnm {boolean} true if curl is installed
##
function check_curl_exists() {
    if [[ -z $(command -v curl) ]]; then
        return ${FALSE}
    fi
    return ${TRUE}
}

##
# print error message
##
function print_error() {
    printf "%s\n" "\033[31mERROR\033[0m$1"
    exit ${FALSE}
}

check_zsh_exists || print_error "zsh is not installed"
check_curl_exists || print_error "curl is not installed"
check_git_exists || print_error "git is not installed"
if ! check_zpm_exists; then
  curl -fsSL -o install.sh https://raw.githubusercontent.com/zpm-shell/zpm/0.0.29/install.sh && source install.sh
fi