#!/usr/bin/env zpm

import ../../bin.zsh --as bin
import ../../log.zsh --as log

##
# @description crate a new package template
# @arg --data|-d - The data to use to create the package, like:
#{
#  "name": "create",
#  "flags": {
#    "template": "package"
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
function create_package() {
    # 1. Process the input.
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

    # 2. Handling the logic.
    # 2.1 Copy the template to the project directory
    cp -r "${ZPM_DIR}/src/utils/zpm/create-package/template" "${projectName}"
    # 2.2 Generate the zpm-package.json file
    call bin.rv \
        version=0.0.1 \
        name="${projectName}" \
        description="a zpm package" \
        -f "${projectName}/zpm-package.json" \
        -o "${projectName}/zpm-package.json"
    # # 2.3 Generate the README.md file.
    call generate_readme "${projectName}" "${projectName}/README.md"
    
    cd ${projectName}
    # echo 
    find . -type f
    cd -
    echo 
    call log.success "The ${projectName} project was created successfully."
}


##
# @Description generate the README.md file
# @Usage: generate_readme <package-name> <file-path>
# @Example: generate_readme hello hello/README.md
# @Return <void>
##
function generate_readme() {
    # 1. Process the input.
    local packageName=$1
    local filePath=$2


    # 2. Process the logic.
    cat > ${filePath} <<EOF
# ${packageName}

A zpm package

## Installation

\`\`\`bash
zpm install github.com/your-username/${packageName}
\`\`\`

## Usage

\`\`\`bash
zpm run start
\`\`\`

## License

ISC
EOF
}