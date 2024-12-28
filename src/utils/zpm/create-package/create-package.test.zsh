#!/usr/bin/env zpm

import ../../../core/test_beta.zsh --as test
import ../../log.zsh --as log

##
# @Description: Test the create_package function
# @Return <void>
##
function test_create_package() {
    local currentDir=$(pwd)
    local tmpDir=$( mktemp -d )
    cd ${tmpDir}
    local packageName='demo-package'
    zpm create ${packageName} -t package
    cd ${currentDir}

    typeset -A willBeCreatedFiles=(
        [zpm-package.json]='ok'
        [README.md]='ok'
        [lib/main.zsh]='ok'
    )
  
    local actualFileCount=0;
    local directory="${tmpDir}/${packageName}"
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