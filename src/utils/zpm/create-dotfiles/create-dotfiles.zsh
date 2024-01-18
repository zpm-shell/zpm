#!/usr/bin/env zpm

import ../../bin.zsh --as bin
import ../../log.zsh --as log

##
# @description crate a new dotfiles project.
# @arg --data|-d - The data to use to cAreate the dotfiles, like:
#{
#  "name": "create",
#  "flags": {
#    "template": "dotfiles"
#  },
#  "args": [
#    {
#      "name": "package name",
#      "value": "hello"
#    }
#  ]
#}
# @return <boolean>
##
function create_dotfiles() {
    local inputData=''
    local args=("$@")
    for (( i = 1; i <= $#; i++ )); do
        local arg="${args[$i]}"
        case "${arg}" in
            --data|-d)
                (( i++ ))
                inputData="${args[$i]}"
            ;;
        esac
    done

    # if the input data is empty, then exit
    if [[ -z "${inputData}" ]]; then
        throw --error-message "The flag: --data|-d was requird" --exit-code 1
    fi
    
    # check if the project name was exists in current directory
    local jq=$( call bin.jq )
    local projectName=$( $jq -j "${inputData}" -q args.0.value -t get )
    if [[ -d "${projectName}" ]]; then
        throw --error-message "The project name: ${projectName} was exists in $(pwd)" --exit-code 1
    fi

    cp -r "${ZPM_DIR}/src/utils/zpm/create-dotfiles/template" "${projectName}"
    call bin.rv \
        VERSION=0.0.1 \
        NAME="${projectName}" \
        DESCRIPTION="a zpm dotfiles" \
        -f "${projectName}/zpm-package.json" \
        -o "${projectName}/zpm-package.json"
    cd ${projectName}
    echo 
    find . -type f
    cd -
    echo 
    call log.success "The ${projectName} project was created successfully."
}