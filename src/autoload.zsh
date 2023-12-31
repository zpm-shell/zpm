#!/usr/bin/env zsh

TRUE=0
FALSE=1

if [[ -z ${ZPM_DIR} ]]; then
    echo "ZPM_DIR is not set"; exit 1;
fi

. ${ZPM_DIR}/src/core/error.zsh #{print_number_line, throw}
. ${ZPM_DIR}/src/core/extract-functions.zsh #{extract_functions}

if [[ -z ${ZPM_WORKSPACE} ]]; then
    ZPM_WORKSPACE=$(pwd)
fi

# the stack is used to store the current workspace path in the call stack
# because the workspace path will be changed in the third-party module,
# like:
# call current-module.func1 -> call third-party-module.func2 -> call third-party-module.func3 ...
# so the workspace path must be changed correctly before the function was called.
# so the ZPM_PACKAGE_WORKSPACE_STACK is used to store the workspace path in the call stack.
# and get the correct workspace path in anywhere module.
# e.g.
# ZPM_PACKAGE_WORKSPACE_STACK=(
#   "/home/xxx/current/project"
#   "/home/xxx/zpm/packages/package1"
#   "/home/xxx/zpm/packages/package2"
#   ...
# )
typeset -g ZPM_PACKAGE_WORKSPACE_STACK=(
    ${ZPM_WORKSPACE}
)

# The global variable will be stored the loaded files,
# and the key is the absolute path of the file, and the value
# is the alias name.
# It is used to register all the files that have been loaded
# andh then based on it to avoid the loop import or the file
# was imported multiple times.
# e.g.
# GLOBAL_SOURCE_FILES=(
#   ["/src/core/error.zsh"]="error"
#   ...
# )
typeset -A -g GLOBAL_SOURCE_FILES=()

##
# storage the stace source file,and the stace file path used to get the 
# missing file in the call stack when the function name was renamed and 
# missing the file path.
##
typeset -A -g STACE_SOURCE_FILE=()

##
# to map the importing file path to multiple alias names
# the global variable is used to find the alias name in the imported file, 
# and check the alias name in the imported file was used or not.
# e.g.
# IMPORT_FILE_MAP_ALIAS_NAMES=(
#   [source_file1]="{"module_name1":true, "module_name2":true, ... }"
#   ...
# )
typeset -A -g IMPORT_FILE_MAP_ALIAS_NAMES=()

##
# @param {string} the module source path
# @param --as {string} the alias name for for module
# @example
#   import /src/core/error.zsh --as error
# @return {void}
##
function import() {
    local from=''
    local as=''
    #1 parse arguments
    local args=("$@")
    local isContinue=${FALSE}
    for (( i = 1; i <= ${#args[@]}; i++)); do
        if [[ ${isContinue} -eq ${TRUE} ]]; then
            isContinue=${FALSE}
            continue
        fi
        local arg=${args[$i]}
        case $arg in
            --as*)
                as="${args[ $i + 1 ]}"
                isContinue=${TRUE}
                continue
                ;;
            --*)
               isContinue=${TRUE}
               continue
               ;;
        esac
        from="${arg}"
    done
    #2 check the args
    #2.1 check the args not empty
    if [[ -z "${from}" ]]; then
        throw --error-message "the arg of module path is required" --exit-code 1 --trace-level 2
    fi
    if [[ -z "${as}" ]]; then
        throw --error-message "the --as arg is required" --exit-code 1 --trace-level 2
    fi
    #3 get the absolute path
    local absolutePath="${from}"
    local isExists="${TRUE}"
    local prevFileLine="${funcfiletrace[1]}"
    case ${absolutePath} in
        /*)
            ;;
        .*)
            # 3.1 get the absolute prev file path
            if [[ ${prevFileLine:0:1} != '/' ]]; then
                prevFileLine="${ZPM_WORKSPACE}/${prevFileLine}"
            fi
            local prevFile="${prevFileLine%:*}"
            local prevDir="${prevFile%/*}"
            # 3.2 get the absolute path
            case ${absolutePath:1:1} in
                /)
                    absolutePath="${prevDir}/${absolutePath:2}"
                    ;;
               .)
                    absolutePath="${prevDir}/${absolutePath}"
                    ;;
            esac
            ;;
        @/*)
            absolutePath="${ZPM_WORKSPACE}/${absolutePath:2}"
            ;;
        *)
            throw --error-message "the module file ${from} not exists" --exit-code 1 --trace-level 2
            ;;
    esac
    # 4 check the file exists
    if [[ ! -f ${absolutePath} ]]; then
        throw --error-message "the module file ${from} not exists" --exit-code 1 --trace-level 2
    fi
    # 5 Simplify the path
    absolutePath=${absolutePath:A}

    # 6 if the file was imported and then return false.
    if [[ -n ${GLOBAL_SOURCE_FILES[$absolutePath]} ]]; then
        return "${TRUE}"
    else
        GLOBAL_SOURCE_FILES[$absolutePath]="${as}"
    fi

    # 7 Verify circul importing file
    if [[ -n ${STACE_SOURCE_FILE[$absolutePath]} ]]; then
        # 7.1 print the loop import file path
        local errorMsg=''
        local isBetweenLoopImport="${FALSE}"
        for staceAbsoluteSourceFile staceFromPath in "${(kv)STACE_SOURCE_FILE[@]}"; do
            if [[ ${absolutePath} == ${staceAbsoluteSourceFile} ]]; then
                isBetweenLoopImport="${TRUE}"
            fi
            if [[ ${isBetweenLoopImport} == ${TRUE} ]]; then
                errorMsg="${errorMsg}${staceFromPath}->"
            fi
        done
        throw --error-message "${errorMsg}${from}" --exit-code 1 --trace-level 2
    fi
    # 8 if the path is already in the stack, then return true
    if [[ -n ${STACE_SOURCE_FILE[${absolutePath}]} ]]; then
        return ${TRUE}
    fi
    # 9 check the alias name was used in the import file
    local prefFile=${prevFileLine%:*}
    local prefFile=${prefFile:A}
    local prefLineNo=${prevFileLine#*:}
    if [[ -n ${IMPORT_FILE_MAP_ALIAS_NAMES[${prefFile}]} ]]; then
        local aliasNamesJson="${IMPORT_FILE_MAP_ALIAS_NAMES[${prefFile}]}"
        result=$(${ZPM_DIR}/src/qjs-tools/bin/alias-name-query "${aliasNamesJson}" -q "${as}" 2>&1)
        # if the command executed successfully with the exit code 0, then the output will be the alias name
        if [[ $? -eq 0 ]]; then
            throw --error-message "the as name '${as}' is already used in the current file '${prefFile#${ZPM_WORKSPACE}/}'" --trace-level 2 --exit-code 1
            return ${FALSE}
        else
            IMPORT_FILE_MAP_ALIAS_NAMES[${prefFile}]="${aliasNamesJson:0:-1},\"${as}\":true}"
        fi
    else
        IMPORT_FILE_MAP_ALIAS_NAMES[${prefFile}]="{\"${as}\":true}"
    fi
    # 10 add the import file path to stace
    STACE_SOURCE_FILE[${absolutePath}]="${from}"

    # 11 source the file
    . ${absolutePath}
    # 12 remove the import file path from stace
    unset "STACE_SOURCE_FILE[${absolutePath}]"

    # 13 get the list of function names from the source file
    local functionNames=($(extract_functions --zsh-file "${absolutePath}" 2>&1))

    # 14 rename the function name in absolutePath as the new name with a prefix of absolutePath
    local initFunctionName=''
    for lineNoAdnFunName in ${functionNames[@]}; do
        local lineNo=${lineNoAdnFunName%:*}
        local oldFunName="${lineNoAdnFunName##*:}"

        # 14.1 rename the function name
        local newFunName="${absolutePath}:${lineNo}:${oldFunName}"
        functions[$newFunName]=${functions[$oldFunName]}
        # 14.2 remove the old function name
        unset "functions[$oldFunName]"

        # if the init functi
        if [[ ${oldFunName} == 'init' ]]; then
            initFunctionName=${newFunName}
        fi
    done
    # if initFunctionName was not empty and then call the function
    if [[ -n ${initFunctionName} ]]; then
        ZPM_CALL_STACE+=("${initFunctionName}")
        ${initFunctionName}
        ZPM_CALL_STACE=(${ZPM_CALL_STACE:0:-1})
    fi
}

##
# call a function by alias name and function name
# @param <alias-name>.<func-name>
# @example
#   call <alias-name>.<func-name> [args...]
# @example
#   call module-name.func-name
# @return {void}
##
function call() {
    # 1 check the args is legal
    local funcAliasName=$1
    # 1.1 check the args not empty
    if [[ -z ${funcAliasName} ]]; then
        throw --error-message "the function name is required"  --trace-level 2
        return ${FALSE}
    fi
    # 1.2 check the args is legal
    local regex="([a-zA-Z0-9_-]+).([a-zA-Z0-9_-]+)"
    local aliasName=''
    local funcName=''
    if [[ $funcAliasName =~ $regex ]]; then
         aliasName=$match[1]
         funcName=$match[2]
    else
        throw --error-message "the function name is not legal"  --trace-level 2
        return ${FALSE}
    fi
    
    # 2 get the loaded path in prev file
    # 2.1 get the prev file path
    local prefFileLine="${funcfiletrace[1]}"
    local prevFilePath="${prefFileLine%:*}"
    prevFilePath="${prevFilePath:A}"

    if [[ -z ${prevFilePath} && ${#ZPM_CALL_STACE[@]} -gt 0 ]]; then
    local funcAliasName=${ZPM_CALL_STACE[-1]}
     prevFilePath=${funcAliasName%%:*}
    fi
    
    # 2.2 get the import path in the current file with the --as name
    local loadedFilePath=$(
        ${ZPM_DIR}/src/qjs-tools/bin/get-import-path-in-zsh-file \
        -f ${prevFilePath} -a ${aliasName} 2>&1
    )
    if [[ $? -ne 0 ]]; then
        throw --error-message "get the import path failed: ${loadedFilePath}"  --trace-level 2
        return ${FALSE}
    fi

    # 3 convert the loaded path to absolute path
    # 3.1 convert the loaded path to absolute path
    case ${loadedFilePath} in
        .*)
            # 3.1 get the absolute prev file path
            local prevDir="${prevFilePath%/*}"
            # 3.2 get the absolute path
            case ${loadedFilePath:1:1} in
                /)
                    loadedFilePath="${prevDir}/${loadedFilePath:2}"
                    ;;
               .)
                    loadedFilePath="${prevDir}/${loadedFilePath}"
                    ;;
            esac
            ;;
        @/*)
            loadedFilePath="${ZPM_WORKSPACE}/${loadedFilePath:3}"
            ;;
    esac
    loadedFilePath=${loadedFilePath:A}
    # 4 contact the function name with the loaded path and function name
    local lineNumbers=($(
        grep -En "^function[[:space:]]+${funcName}\(\)|[[:space:]]*${funcName}\(\)" "${loadedFilePath}"  \
          | sed -E "s/^([0-9]+):[[:space:]]*(function[[:space:]]+)*(.*)\(\).*/\1/g" \
          | xargs
    ))
    local lineNumber=${lineNumbers[-1]}
    local funcAliasName="${loadedFilePath}:${lineNumber}:${funcName}"

    # 5 check the function exists
    if [[ -z ${functions[$funcAliasName]} ]]; then
        throw --error-message "the function ${aliasName}.${funcName} not exists"  --trace-level 2
        return ${FALSE}
    fi
    # 6 Add the loaded path to call stace
    ZPM_CALL_STACE+=("${funcAliasName}")

    # 7 call the funcation with the args
    shift 1
    ${funcAliasName} $@
    local result=$?

    # 8 remove the loaded path from call stace

    ZPM_CALL_STACE=(${ZPM_CALL_STACE:0:-1})
    
    return ${result}
}

local sourceFile=''
local args=("$@")
for (( i = 1; i <= ${#args[@]}; i++ )); do
  local arg=${args[$i]}
  case ${arg}; in
    --source)
        sourceFile=$2
        shift 2
    ;;
  esac
done

if [[ -f ${sourceFile} ]]; then
    . ${sourceFile}
elif [[ -n ${sourceFile} ]]; then
    throw --error-message "the file: ${sourceFile} was not exited" --exit-code 1
fi
