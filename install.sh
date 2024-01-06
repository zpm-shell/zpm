#!/usr/bin/env bash
# Install script for the zpm(zsh package manager)

TRUE=0
FALSE=1

VERSION_NAME="0.0.1"

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

# download the zpm
save_dir="~/.zpm"
git clone https://github.com/zpm-shell/zpm ${save_dir}
cd ${save_dir}
git checkout ${VERSION_NAME}

# add the zpm to the zshrc
start_start_symbol="# zpm conf start"
end_start_symbol="# zpm conf end"
config_in_zshrc=$(cat <<EOF
${start_start_symbol}
export ZPM_DIR=${save_dir}
export PATH=\${ZPM_DIR}/bin:\${PATH}
${end_start_symbol}
EOF
)

if [ -f ~/.zshrc ]; then
    if grep -q "${start_start_symbol}" ~/.zshrc; then
        echo "zpm already configured in ~/.zshrc"
    else
        echo "${config_in_zshrc}" >> ~/.zshrc
    fi
    # load the zpm in the current shell
    eval "${config_in_zshrc}"
    # echo the message: the config ${config_in_zshrc} is added to ~/.zshrc
    echo "${config_in_zshrc}"
    echo "the zpm config is added to ~/.zshrc"
    echo "zpm installed successfully"
else
    echo "${config_in_zshrc}" >> ~/.zshrc
fi
