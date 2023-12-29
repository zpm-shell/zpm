#!/usr/bin/env zsh

import ./zpm.zsh --as self

##
# print a message
# @param --message|-m <string> The error message
# @return <boolean>
##
function zpm_error() {
    local inputMsg=''
    local args=("$@")
    for (( i = 1; i <= $#; i++ )); do
        local arg="${args[$i]}"
        case "${arg}" in
            --message|-m)
                (( i++ ))
                inputMsg="${args[$i]}"
            ;;
        esac
    done
    if [[ -z "${inputMsg}" ]]; then
        throw --error-message "The flag: --message|-m was requird" --exit-code 1
    fi
    echo "\e[1;41m ERROR \e[0m ${inputMsg}" >&2
}

##
# create a zpm.json5 file
# @param --data|-d <json5> like: {name: "init", args: [], flags: {}, description: "Create a zpm.json5 file"}
# @return <void>
##
function create_zpm_json5() {
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

    # if the zpm.json5 file exists, then exit
    if [[ -f "zpm.json5" ]]; then
        throw --error-message "The zpm.json5 file already exists" --exit-code 1
    fi

    local jq5=${ZPM_DIR}/src/qjs-tools/bin/json5-query
    local packageName=$($jq5 -j "${inputData}" -q "args.0.value" -t get)

    local config=$(cat <<EOF
{
    name: "${packageName}",
    version: "1.0.0",
    description: "A zpm package",
    main: "src/main.zsh",
    scripts: {
        test: "echo \"Error: no test specified\" && exit 1"
    },
    keywords: [],
    author: "",
    license: "ISC"
}
EOF
)
    local conf_file="zpm.json5"
    echo "${config}" > ${conf_file}
    echo "${config}"
    echo "Create ${conf_file} success"
}

##
# run a script in zpm.json5
# @param --data|-d <json5> like: {name: "init", args: [], flags: {}, description: "Create a zpm.json5 file"}
# @return <void>
##
function run_script() {
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

    local zpmJson5="zpm.json5"
    # if the zpm.json5 file exists, then exit
    if [[ ! -f "${zpmJson5}" ]]; then
        call self.zpm_error -m "No ${zpmJson5} was found in \"$(pwd)\""
         return 1;
    fi
    local jq5=${ZPM_DIR}/src/qjs-tools/bin/json5-query
    local scriptName=$($jq5 -j "${inputData}" -q "args.0.value" -t get)
    # check if the script name was not exits and then print the error message
    local zpmJson5Data=$(cat ${zpmJson5})
    local hasScripName=$($jq5 -j "${zpmJson5Data}" -q "scripts.${scriptName}" -t has)
    if [[ ${hasScripName} == "false" ]]; then
        call self.zpm_error -m "No script name: ${scriptName} was found in ${zpmJson5}"
        return ${FALSE}
    fi

    # run the script
    local cmdData=$($jq5 -j "${zpmJson5Data}" -q "scripts.${scriptName}" -t get)
    eval " ${cmdData}"
}