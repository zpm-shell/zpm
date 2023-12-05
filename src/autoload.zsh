#!/usr/bin/env zsh

TRUE=0
FALSE=1

if [[ -z ${ZMOD_DIR} ]]; then
    echo "ZMOD_DIR is not set"; exit 1;
fi

. ${ZMOD_DIR}/src/utils/test.zsh
. ${ZMOD_DIR}/src/utils/error.zsh
. ${ZMOD_DIR}/src/utils/debug.zsh
. ${ZMOD_DIR}/src/utils/extract-functions.zsh

if [[ -z ${ZMOD_APP_PATH} ]]; then
    throw --error-message "the ZMOD_APP_PATH is not set" --exit-code 1
fi

# global source files, which will be stored the loaded files
typeset -A -g GLOBAL_SOURCE_FILES=()
typeset -A -g STACE_SOURCE_FILE=()

##
# @param --from {string} the module source path
# @param --as {string} the alias name for for module
# @example
#   import --from /src/utils/error.zsh --as error
# @return {void}
##
function import() {
    local from=''
    local as=''
    #1 parse arguments
    for i in "$@"; do
        case $i in
            --from*)
                from="$2"
                shift
                ;;
            --as*)
                as="$2"
                shift
                ;;
            *)
            shift;
            ;;
        esac
    done
    #2 check the args
    #2.1 check the args not empty
    if [[ -z "${from}" ]]; then
        throw --error-message "the --from arg is required" --exit-code 1 --trace-level 2
    fi
    if [[ -z "${as}" ]]; then
        throw --error-message "the --as arg is required" --exit-code 1 --trace-level 2
    fi
    #3 get the absolute path
    local absolutePath="${from}"
    local isExists="${TRUE}"
    case ${absolutePath} in
        /*)
            ;;
        .*)
            # 3.1 get the absolute prev file path
            local prevFileLine="${funcfiletrace[1]}"
            if [[ ${prevFileLine:0:1} != '/' ]]; then
                prevFileLine="${ZMOD_APP_PATH}/${prevFileLine}"
            fi
            local prevFile="${prevFileLine%:*}"
            local prevDir="${prevFile%/*}"
            # 3.2 get the absolute path
            case ${absolutePath:1:1} in
                /)
                    absolutePath="${prevDir}/${absolutePath:2}"
                    ;;
               .)
                    absolutePath="${prevDir}/${absolutePath:3}"
                    ;;
            esac
            ;;
        @/*)
            absolutePath="${ZMOD_APP_PATH}/${absolutePath:3}"
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

    # 6 check the file not imported
    if [[ -n ${GLOBAL_SOURCE_FILES[$absolutePath]} ]]; then
        return "${FALSE}" 
    else
        GLOBAL_SOURCE_FILES[$absolutePath]="${as}"
    fi

    # 7 Verify Loop import
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
    # 8 add the import file path to stace
    STACE_SOURCE_FILE[${absolutePath}]="${from}"
    # 9 source the file
    source ${absolutePath}
    #f10 remove the import file path from stace
    unset "STACE_SOURCE_FILE[${absolutePath}]"

    # 11 get the list of function names from the source file
    local functionNames=($(extract_functions --zsh-file "${absolutePath}"))

    # 12 rename the function name in absolutePath as the new name with a prefix of absolutePath
    for lineNoAdnFunName in ${functionNames[@]}; do

        local lineNo=${lineNoAdnFunName%:*}
        local oldFunName="${lineNoAdnFunName##*:}"

        # 12.1 rename the function name
        local newFunName="${absolutePath}:${lineNo}:${oldFunName}"
        functions[$newFunName]=${functions[$oldFunName]}
        # 12.2 remove the old function name
        unset "functions[$oldFunName]"
    done
}

function qjs() {
    ${ZMOD_DIR}/bin/qjs_$(uname -s)_$(uname -m) "$@"
}

typeset CALL_TRACE=()
function get_call_trace_file() {
    echo "${CALL_TRACE[@]}"
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

    if [[ -z ${prevFilePath} && ${#CALL_STACE[@]} -gt 0 ]]; then
    local funcAliasName=${CALL_STACE[-1]}
     prevFilePath=${funcAliasName%%:*}
    fi
    
    # 2.2 get the loaded path
    local loadedFilePath=$(
        ${ZMOD_DIR}/bin/qjs_$(uname -s)_$(uname -m) \
        ${ZMOD_DIR}/src/js-scripts/src/get_loaded_path_in_zsh_file.js \
        -f ${prevFilePath} -a ${aliasName}
    )
    if [[ ${loadedFilePath} == '{}' ]]; then
        throw --error-message "get the loaded path failed: ${loadedFilePath}"  --trace-level 2
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
                    loadedFilePath="${prevDir}/${loadedFilePath:3}"
                    ;;
            esac
            ;;
        @/*)
            loadedFilePath="${ZMOD_APP_PATH}/${loadedFilePath:3}"
            ;;
    esac
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
    CALL_STACE+=("${funcAliasName}")

    # 7 call the funcation with the args
    shift 1
    ${funcAliasName} $@

    # 8 remove the loaded path from call stace

    CALL_STACE=(${CALL_STACE:0:-1})
}

import --from ./modules/m1.zsh --as m1

# for funcName in ${(k)functions[@]}; do
#     echo "funcName: ${funcName}"
# done
# /Users/wuchuheng/.zmod/src/modules/m2.zsh:3:m2
call m1.m1
# /Users/wuchuheng/.zmod/src/modules/m2.zsh:m2:212
# command /Users/wuchuheng/.zmod/src/modules/m2.zsh:m2

# /Users/wuchuheng/.zmod/src/modules/m1.zsh:m1:5