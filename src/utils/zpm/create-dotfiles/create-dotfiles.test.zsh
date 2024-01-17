#!/usr/bin/env zpm

import ../../../core/test_beta.zsh --as test
import ../../log.zsh --as log

function test_create_dotfiles() {
    local currentDir=$(pwd)
    local tmpDir=$( mktemp -d )
    cd ${tmpDir}
    zpm create dotfiles -t dotfiles
    cd ${currentDir}

    typeset -A willBeCreatedFiles=(
        [zpm-package.json]='ok'
        [install.zsh]='ok'
        [src/main.zsh]='ok'
        [src/plugins/first-plugin.zsh]='ok'
    )
  
    local actualFileCount=0;
    local directory="${tmpDir}/dotfiles"
    find ${directory} -type f | while read file; do
        local isFileExisted=${FALSE}
        local file=${file#${directory}/}
        if [[ -n "${willBeCreatedFiles[${file}]}" ]]; then
            isFileExisted=${TRUE}
        fi
        call test.equal -a "${isFileExisted}" -e ${TRUE}
        if [[ $? -gt 0 ]]; then
            call log.error "The file: ${file} was not in the list of will be created files"
        fi
        (( actualFileCount++ ))
    done

    call test.equal -a "${actualFileCount}" -e "${#willBeCreatedFiles[@]}"
}