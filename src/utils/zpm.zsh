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
# create a zpm-package.json5 file
# @param --data|-d <json5> like: {name: "init", args: [], flags: {}, description: "Create a zpm-package.json5 file"}
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

    # if the zpm-package.json5 file exists, then exit
    if [[ -f "zpm-package.json5" ]]; then
        throw --error-message "The zpm-package.json5 file already exists" --exit-code 1
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
    local conf_file="zpm-package.json5"
    echo "${config}" > ${conf_file}
    echo "${config}"
    echo "Create ${conf_file} success"
}

##
# exec a zsh script
# @param --file|-f <string> The file path
# @return <void>
##
function exec_zsh_script() {
    local inputFile=''
    local args=("$@")
    for (( i = 1; i <= $#; i++ )); do
        local arg="${args[$i]}"
        case "${arg}" in
            --file|-f)
                (( i++ ))
                inputFile="${args[$i]}"
            ;;
        esac
    done
    if [[ -z "${inputFile}" ]]; then
        throw --error-message "The flag: --file|-f was requird" --exit-code 1
    fi
    
    # check the file was zsh file
    local fileExt=$(echo "${inputFile}" | awk -F '.' '{print $NF}')
    if [[ "${fileExt}" != "zsh" ]]; then
        call self.zpm_error -m "The file: ${inputFile} is not a zsh file"
        return ${FALSE}
    fi

    . ${inputFile}
}

##
# run a script in zpm-package.json5
# @param --data|-d <json5> like: {name: "init", args: [], flags: {}, description: "Create a zpm-package.json5 file"}
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

    local zpmJson5="zpm-package.json5"
    # if the zpm-package.json5 file exists, then exit
    if [[ ! -f "${zpmJson5}" ]]; then
        call self.zpm_error -m "No ${zpmJson5} was found in \"$(pwd)\""
         return 1;
    fi
    local jq5=${ZPM_DIR}/src/qjs-tools/bin/json5-query
    local scriptName=$($jq5 -j "${inputData}" -q "args.0.value" -t get)
    if [[ -f ${scriptName} ]]; then
        call self.exec_zsh_script -f ${scriptName}
        return $?;
    else
        # check the script name was included dot
        local hasDot=$(echo "${scriptName}" | grep -e "\.\\?.*\.[a-zA-Z0-9]\\+$" )
        if [[ -n "${hasDot}" ]]; then
            call self.zpm_error -m "the script file: ${scriptName} was not found in \"$(pwd)\""
            return ${FALSE}
        fi
    fi
    # check if the script name was not exits and then print the error message
    local zpmJson5Data=$(cat ${zpmJson5})
    local hasScripName=$($jq5 -j "${zpmJson5Data}" -q "scripts.${scriptName}" -t has)
    if [[ ${hasScripName} == "false" ]]; then
        if [[ -f ${scriptName} ]]; then
            call self.exec_zsh_script -f ${scriptName}

        else
            call self.zpm_error -m "No script name: ${scriptName} was found in ${zpmJson5}"
            return ${FALSE}
        fi
    fi

    # run the script
    local cmdData=$($jq5 -j "${zpmJson5Data}" -q "scripts.${scriptName}" -t get)
    eval " ${cmdData}"
}

##
# install a package
# @param --data|-d <json5> like: {name: "init", args: [], flags: {}, description: "Create a zpm-package.json5 file"}
# @return <void>
##
function install_package() {
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
    local packageName=$($jq5 -j "${inputData}" -q "args.0.value" -t get)
    
    # check the git cmd was exists
    if [[ ! -x "$(command -v git)" ]]; then
        call self.zpm_error -m "The git command was required to install a package"
        return ${FALSE}
    fi

    local savePackageDir="${ZPM_DIR}/packages/${packageName}"
    if [[ ! -d ${savePackageDir} ]]; then
        mkdir -p ${savePackageDir}
    fi

    # download the package to the packages directory.
    local tmpSavePackageDir=$(mktemp -d)
    git clone https://${packageName} ${tmpSavePackageDir}
    cd ${tmpSavePackageDir}
    # get the lastest commit id and rename the directory with the commit id
    local commitId=$(git rev-parse HEAD)
    mv ${tmpSavePackageDir} ${savePackageDir}/${commitId}
    cd -
    # update the zpm-package.json5 file
    local editZpmJson5Dependencies="${ZPM_DIR}/src/qjs-tools/bin/edit-zpm-json5-dependencies"
    local zpmJson5="zpm-package.json5"
    local newJson5Data=$(
    ${editZpmJson5Dependencies} -f ${zpmJson5} \
        -k "${packageName}" \
        -v "${commitId}" -a set )
    cat > ${zpmJson5} <<EOF
${newJson5Data}
EOF
}