#!/usr/bin/env zsh

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
    local packageName=$($jq5 -j "${inputData}" -q "args.0")

    local zpm_json5=$(cat <<EOF
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
    echo "${zpm_json5}" > zpm.json5
    echo "${zpm_json5}"
    echo "create zpm.json5 success"
}