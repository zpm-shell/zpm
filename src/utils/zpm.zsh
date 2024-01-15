#!/usr/bin/env zsh

import ./zpm.zsh --as self
import ../core/test_beta.zsh --as test
import ./global.zsh --as global
import ./color.zsh --as color

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
# create a zpm-package.json file
# @param --data|-d <json> like: {name: "init", args: [], flags: {}, description: "Create a zpm-package.json file"}
# @return <void>
##
function create_zpm_json() {
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

    # if the zpm-package.json file exists, then exit
    if [[ -f "zpm-package.json" ]]; then
        throw --error-message "The zpm-package.json file already exists" --exit-code 1
    fi

    local jq=${ZPM_DIR}/src/qjs-tools/bin/jq
    local packageName=$($jq -j "${inputData}" -q "args.0.value" -t get)

    local config=$(cat <<EOF
{
    "name": "${packageName}",
    "version": "1.0.0",
    "description": "A zpm package",
    "main": "lib/main.zsh",
    "scripts": {
        "start": "zpm run lib/main.zsh",
        "test": "echo \"Error: no test specified\" && exit 1"
    },
    "keywords": [],
    "author": "",
    "license": "ISC"
}
EOF
)
    local conf_file="zpm-package.json"
    echo "${config}" > ${conf_file}
    echo "${config}"
    echo "Create ${conf_file} success"
    # create lib/main.zsh file
    local libDir="lib"
    if [[ ! -d ${libDir} ]]; then
        mkdir -p ${libDir}
    fi
    cat > ${libDir}/main.zsh <<EOF
#!/usr/bin/env zpm
function() {
    echo "Hello world"
}
EOF

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
# run a script in zpm-package.json
# @param --data|-d <json> like: {name: "init", args: [], flags: {}, description: "Create a zpm-package.json file"}
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

    local zpmjson="zpm-package.json"
    # if the zpm-package.json file exists, then exit
    if [[ ! -f "${zpmjson}" ]]; then
        call self.zpm_error -m "No ${zpmjson} was found in \"$(pwd)\""
         return 1;
    fi
    local jq=${ZPM_DIR}/src/qjs-tools/bin/jq
    local scriptName=$($jq -j "${inputData}" -q "args.0.value" -t get)
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
    local zpmjsonData=$(cat ${zpmjson})
    local hasScripName=$($jq -j "${zpmjsonData}" -q "scripts.${scriptName}" -t has)
    if [[ ${hasScripName} == "false" ]]; then
        if [[ -f ${scriptName} ]]; then
            call self.exec_zsh_script -f ${scriptName}

        else
            call self.zpm_error -m "No script name: ${scriptName} was found in ${zpmjson}"
            return ${FALSE}
        fi
    fi

    # run the script
    local cmdData=$($jq -j "${zpmjsonData}" -q "scripts.${scriptName}" -t get)
    eval " ${cmdData}"
}

##
# install a package
# @param --data|-d <json> like: {name: "init", args: [], flags: {}, description: "Create a zpm-package.json file"}
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

    local totalArgs=$($jq -j "${inputData}" -q "args" -t size)
    # install all dependences
    if [[ ${totalArgs} -eq 0 ]]; then
        call self.install_all_dependence -d ${inputData}
        return $?
    fi

    # install a dependence
    local packageName=$($jq -j "${inputData}" -q "args.0.value" -t get)
    
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
    # move the package directory to the package saved directory
    local packageSaveDir="${savePackageDir}/${commitId}"
    if [[ ! -d ${packageSaveDir} ]]; then
        mv ${tmpSavePackageDir} ${savePackageDir}/${commitId}
    fi
    cd -
    # update the zpm-package.json file
    local editZpmJson5Dependencies="${ZPM_DIR}/src/qjs-tools/bin/edit-zpm-json-dependencies"
    local zpmjson="zpm-package.json"
    local newjsonData=$(
    ${editZpmJson5Dependencies} -f ${zpmjson} \
        -k "${packageName}" \
        -v "${commitId}" -a set )
    cat > ${zpmjson} <<EOF
${newjsonData}
EOF
}

##
# uninstall a package
# @param --data|-d <json> like: {name: "uninstall", args: [], flags: {}, description: "Create a zpm-package.json file"}
# @return <void>
##
function uninstall_package() {
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
    local packageName=$($jq -j "${inputData}" -q "args.0.value" -t get)
    
    # check if the package name was not empty.
    if [[ -z "${packageName}" ]]; then
        call self.zpm_error -m "The package name was required"
        return ${FALSE}
    fi

    # check the zpm-package.json was existed or not.
    local zpmjson="zpm-package.json"
    if [[ ! -f ${zpmjson} ]]; then
        call self.zpm_error -m "No ${zpmjson} was found in \"$(pwd)\""
        return ${FALSE}
    fi

    local zpmjsonData=$(cat ${zpmjson})
    # check if the package was installed.
    local jq=${ZPM_DIR}/src/qjs-tools/bin/jq
    packageName=$(echo "${packageName}" | sed 's/\./\\./g')
    local hasPackage=$($jq -j "${zpmjsonData}" -q "dependencies.${packageName}" -t has)
    if [[ ${hasPackage} == "false" ]]; then
        packageName=$(echo "${packageName}" | sed 's/\\./\./g')
        call self.zpm_error -m "The package: ${packageName} was not installed"
        return ${FALSE}
    fi

    local jsonStr=$($jq -j "${zpmjsonData}" -q "dependencies.${packageName}" -t delete)
    cat > ${zpmjson} <<EOF
${jsonStr}
EOF
}

function test() {

    typeset -g TRUE=0
    typeset -g FALSE=1
    
    typeset -g TOTAL_TESTS=0
    typeset -g TOTAL_FAILED_TESTS=0
    typeset -g TOTAL_PASSED_TESTS=0
    
    typeset -g START_TIME=$(date +%s )
    typeset -g TOTAL_FILES=0
    
    typeset -g IS_CURRENT_TEST_OK=${FALSE}
    typeset -g CURRENT_TEST_FILE=''
    typeset -g CURRENT_TEST_NAME=''

    # TODO(feat): The cmd exclude the test directory,and when the test feature was implemented, then remove this limit. like: 
    # find . -name '*.test.zsh'
    local testFiles=($(find . -path './test' -prune -o -name '*.test.zsh' -print))
for testFile in ${testFiles[@]}; do
  local relativeTestFile=${testFile#./}
  local block="\e[1m"
  local noColor="\e[0m"
  echo "${block}TEST${noColor}  ${relativeTestFile}"
# load the test file
  . ${testFile}

  call global.set "TOTAL_FILES" "$(( TOTAL_FILES + 1 ))"
  
  # loop the test functions
  call global.set "CURRENT_TEST_FILE" "${relativeTestFile}"
  local testFunctions=($(call test.extract_test_functions ${testFile}))
  local testFunc=''
  for testFunc in ${testFunctions[@]}; do
    # execute the test function
    call global.set "CURRENT_TEST_NAME" "${testFunc}"
    call global.set IS_CURRENT_TEST_OK "${TRUE}"
    ${testFunc}
    call test.print_current_test_result ${testFunc} ${IS_CURRENT_TEST_OK}
    # Collecting test data
    call global.set "TOTAL_TESTS" "$(( TOTAL_TESTS + 1 ))"
    if [[ ${IS_CURRENT_TEST_OK} -eq ${TRUE} ]]; then
      call global.set "TOTAL_PASSED_TESTS" "$(( TOTAL_PASSED_TESTS + 1 ))"
    else
      call global.set "TOTAL_FAILED_TESTS" "$(( TOTAL_FAILED_TESTS + 1 ))"
    fi
  done
done

    call color.reset
    call color.light_red
    call color.shape_bold
    local COLOR_TOTAL_FAILED_TESTS=$(call color.print ${TOTAL_FAILED_TESTS})

    call color.reset
    call color.light_green
    call color.shape_bold
    local COLOR_TOTAL_PASSED_TESTS=$(call color.print ${TOTAL_PASSED_TESTS})

    call color.reset
    call color.shape_bold
    local COLOR_TOTAL_FILES=$(call color.print ${TOTAL_TESTS})
    
echo "
Tests:        ${COLOR_TOTAL_FAILED_TESTS} failed, ${COLOR_TOTAL_PASSED_TESTS} passed, ${COLOR_TOTAL_FILES} total
Time:         $(( $(date +%s) - ${START_TIME} )) s
Test files:   ${TOTAL_FILES} f
Ran all test files."

    if [[ ${TOTAL_FAILED_TESTS} -gt 0 ]]; then
        exit 1;
    fi
}

##
# install all dependences for the current project
# @param --data|-d <json> like: {name: "install", args: [], flags: {}, description: "Create a zpm-package.json file"}
# @return <boolean>
##
function install_all_dependence() {
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

    # check the zpm-package.json file was existed or not.
    local zpmjson="zpm-package.json"
    if [[ ! -f ${zpmjson} ]]; then
        call self.zpm_error -m "No ${zpmjson} was found in \"$(pwd)\""
        return ${FALSE}
    fi
}