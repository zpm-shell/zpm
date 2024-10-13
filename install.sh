#!/usr/bin/env bash
# Install script for the zpm(zsh package manager)

TRUE=0
FALSE=1

VERSION_NAME="0.1.7"

##
# print error message
##
function print_error() {
    echo -e "\033[1;31mERROR: \033[0m$1"
    exit ${FALSE}
}

##
# print success message
##
function print_success() {
    echo -e "\033[1;32mSUCCESS: \033[0m$1"
}
print_success hello

##
# print info message
##
function print_info() {
    echo -e "\033[1;34mINFO: \033[0m$1"
}

##
# check the current shell is zsh or not
##
function check_zsh_shell() {
    if [ -n "${ZSH_VERSION}" ]; then
        return ${TRUE}
    fi
    return ${FALSE}
}

##
# check the current shell is bash or not
##
function check_bash_shell() {
    if [ -n "${BASH_VERSION}" ]; then
        return ${TRUE}
    fi
    return ${FALSE}
}

# if the current shell is not zsh or bash, exit
if ! check_zsh_shell && ! check_bash_shell; then
    echo "Please use zsh or bash to continue"
    return 1
fi

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


# 1. Process the input.

# 2. Process the logic.
# 2.1 Download the zpm source code.
# download the zpm
save_dir=~/.zpm
git clone --branch ${VERSION_NAME} --single-branch https://github.com/zpm-shell/zpm ${save_dir}

# 2.2 Add the zpm environment variable to the zshrc.
start_start_symbol="# zpm conf start"
end_start_symbol="# zpm conf end"
config_in_zshrc=$(cat <<EOF
${start_start_symbol}
export ZPM_DIR=${save_dir}
export PATH=\${ZPM_DIR}/bin:\${PATH}
${end_start_symbol}
EOF
)

# set the zpm config in the ~/.zshrc
[ ! -f ~/.zshrc ] && touch ~/.zshrc
if grep -q "${start_start_symbol}" ~/.zshrc; then
    echo "zpm already configured in ~/.zshrc"
else
    echo "${config_in_zshrc}" >> ~/.zshrc
fi

# 2.3 Load the zpm in the current shell
eval "${config_in_zshrc}"

# 2.4 Remove the install script
if [ -f install.sh ]; then
    rm install.sh
fi

# 3. Print the message.
print_info "${config_in_zshrc}"
print_info "the zpm config is added to ~/.zshrc"
print_success "zpm installed successfully"

