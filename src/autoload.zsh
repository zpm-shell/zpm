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

if [[ -z ${ZMOD_WORKSPACE} ]]; then
    throw --error-message "the ZMOD_WORKSPACE is not set" --exit-code 1
fi

# global source files, which will be stored the loaded files
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
    local args=("$@")
    for (( i = 1; i <= ${#args[@]}; i++)); do
        local arg=${args[$i]}
        case $arg in
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
    local prevFileLine="${funcfiletrace[1]}"
    case ${absolutePath} in
        /*)
            ;;
        .*)
            # 3.1 get the absolute prev file path
            if [[ ${prevFileLine:0:1} != '/' ]]; then
                prevFileLine="${ZMOD_WORKSPACE}/${prevFileLine}"
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
            absolutePath="${ZMOD_WORKSPACE}/${absolutePath:2}"
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
        result=$(${ZMOD_WORKSPACE}/src/qjs-tools/bin/alias-name-query "${aliasNamesJson}" -q "${as}" 2>&1)
        # if the command executed successfully with the exit code 0, then the output will be the alias name
        if [[ $? -eq 0 ]]; then
            throw --error-message "the as name '${as}' is already used in the current file '${prefFile#${ZMOD_WORKSPACE}/}'" --trace-level 2 --exit-code 1
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
    local functionNames=($(extract_functions --zsh-file "${absolutePath}"))

    # 14 rename the function name in absolutePath as the new name with a prefix of absolutePath
    for lineNoAdnFunName in ${functionNames[@]}; do

        local lineNo=${lineNoAdnFunName%:*}
        local oldFunName="${lineNoAdnFunName##*:}"

        # 14.1 rename the function name
        local newFunName="${absolutePath}:${lineNo}:${oldFunName}"
        functions[$newFunName]=${functions[$oldFunName]}
        # 14.2 remove the old function name
        unset "functions[$oldFunName]"
    done
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
    
    # 2.2 get the import path in the current file with the --as name
    local loadedFilePath=$(
        ${ZMOD_DIR}/src/qjs-tools/bin/get-import-path-in-zsh-file \
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
                    loadedFilePath="${prevDir}/${loadedFilePath:3}"
                    ;;
            esac
            ;;
        @/*)
            loadedFilePath="${ZMOD_WORKSPACE}/${loadedFilePath:3}"
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

