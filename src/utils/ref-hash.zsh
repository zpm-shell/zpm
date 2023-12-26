##
# create a hash list with a given reference name.
# @param --ref|-r <ref> The name of the variable to create.
# @return <boolean>
##
function create() { 
    local inputRef=''
    local args=("$@")
    local i;
    for (( i = 1; i <= ${#args}; i++ )); do
        local arg="${args[$i]}"
        if [[ "$arg" == '--ref' || "$arg" == '-r' ]]; then
            inputRef="${args[$i+1]}"
            break
        fi
    done
    # if the input ref was empty, then throw an error.
    if [[ -z "$inputRef" ]]; then
        throw --error-message "--ref|-r <ref> is required."
        return ${FALSE}
    fi

    eval "typeset -g -A ${inputRef}=()"
}

##
# get the keys of a hash list.
# @param --ref|-r <ref> The name of the variable to create.
# @return (el1 el2 ...)
##
function keys() { 
    local inputRef=''
    local args=("$@")
    local i;
    for (( i = 1; i <= ${#args}; i++ )); do
        local arg="${args[$i]}"
        if [[ "$arg" == '--ref' || "$arg" == '-r' ]]; then
            inputRef="${args[$i+1]}"
            break
        fi
    done

    # if the input ref was empty, then throw an error.
    if [[ -z "$inputRef" ]]; then
        throw --error-message "--ref|-r <ref> is required."
        return ${FALSE}
    fi

    # if the input ref was not a hash list, then throw an error.
    local actualType=$(typeset -p ${inputRef} 2>/dev/null)
    if [[ "$actualType" != 'typeset -g -A '* ]]; then
        throw --error-message "The reference variable --ref|-r <ref> must be a hash list."
        return ${FALSE}
    fi
    
    # get the keys.
    eval "
        echo \${(@k)${inputRef}}
    "
}

##
# @param --ref|-r <ref> The name of the variable to create.
# @return (el1 el2 ...)
##
function values() { 
    local inputRef=''
    local args=("$@")
    local i;
    for (( i = 1; i <= ${#args}; i++ )); do
        local arg="${args[$i]}"
        if [[ "$arg" == '--ref' || "$arg" == '-r' ]]; then
            inputRef="${args[$i+1]}"
            break
        fi
    done

    # if the input ref was empty, then throw an error.
    if [[ -z "$inputRef" ]]; then
        throw --error-message "--ref|-r <ref> is required."
        return ${FALSE}
    fi

    # if the input ref was not a hash list, then throw an error.
    local actualType=$(typeset -p ${inputRef} 2>/dev/null)
    if [[ "$actualType" != 'typeset -g -A '* ]]; then
        throw --error-message "The reference variable --ref|-r <ref> must be a hash list."
        return ${FALSE}
    fi
    
    # get the keys.
    eval "
        echo \${${inputRef}[@]}
    "
}

##
# @param --ref|-r <ref> The name of the variable to create.
# @param --key|-k <key> The key to get.
# @return <string>
##
function get() { 
    local inputRef=''
    local inputKey=''
    local args=("$@")
    local i;
    for (( i = 1; i <= ${#args}; i++ )); do
        local arg="${args[$i]}"
        if [[ "$arg" == '--ref' || "$arg" == '-r' ]]; then
            inputRef="${args[$i+1]}"
        elif [[ "$arg" == '--key' || "$arg" == '-k' ]]; then
            inputKey="${args[$i+1]}"
        fi
    done

    # if the input ref was empty, then throw an error.
    if [[ -z "$inputRef" ]]; then
        throw --error-message "--ref|-r <ref> is required."
        return ${FALSE}
    elif [[ -z "$inputKey" ]]; then
        throw --error-message "--key|-k <key> is required."
        return ${FALSE}
    fi

    # if the input ref was not a hash list, then throw an error.
    if [[ "$(typeset -p ${inputRef} 2>/dev/null)" != 'typeset -g -A '* ]]; then
        throw --error-message "The reference variable --ref|-r <ref> must be a hash list."
        return ${FALSE}
    fi

    # check the key exists.
    eval "
        if [[ ! -v ${inputRef}[\$inputKey] ]]; then
            throw --error-message "The key:${inputKey} does not exist."
            return ${FALSE}
        fi
    "

    # get the value.
    eval "
        echo \"\${${inputRef}[$inputKey]}\"
    "
}

##
# @param --ref|-r <ref> The name of the variable to create.
# @param --key|-k <key> The key to set.
# @param --value|-v <value> The value to set.
# @return <boolean>
##
function set() { 
    local inputRef=''
    local inputKey=''
    local inputValue=''
    local args=("$@")
    local i;
    for (( i = 1; i <= ${#args}; i++ )); do
        local arg="${args[$i]}"
        if [[ "$arg" == '--ref' || "$arg" == '-r' ]]; then
            inputRef="${args[$i+1]}"
        elif [[ "$arg" == '--key' || "$arg" == '-k' ]]; then
            inputKey="${args[$i+1]}"
        elif [[ "$arg" == '--value' || "$arg" == '-v' ]]; then
            inputValue="${args[$i+1]}"
        fi
    done
    # if the input ref was empty, then throw an error.
    if [[ -z "$inputRef" ]]; then
        throw --error-message "--ref|-r <ref> is required."
        return ${FALSE}
    elif [[ -z "$inputKey" ]]; then
        throw --error-message "--key|-k <key> is required."
        return ${FALSE}
    elif [[ -z "$inputValue" ]]; then
        throw --error-message "--value|-v <value> is required."
        return ${FALSE}
    fi

    # check the reference variable type
    local actualType=$(typeset -p ${inputRef} 2>/dev/null)
    if [[ "$actualType" != 'typeset -g -A '* ]]; then
        throw --error-message "The reference variable --ref|-r <ref> must be a hash list."
        return ${FALSE}
    fi
    
    # set the value.
    eval "${inputRef}[${inputKey}]='${inputValue}'"
    
    return $?
}

##
# @param --ref|-r <ref> The name of the variable to create.
# @param --key|-k <key> The key to delete.
# @return <boolean>
##
function delete() { 
    local inputRef=''
    local inputKey=''
    local args=("$@")
    local i;
    for (( i = 1; i <= ${#args}; i++ )); do
        local arg="${args[$i]}"
        if [[ "$arg" == '--ref' || "$arg" == '-r' ]]; then
            inputRef="${args[$i+1]}"
        elif [[ "$arg" == '--key' || "$arg" == '-k' ]]; then
            inputKey="${args[$i+1]}"
        fi
    done

    # if the input ref was empty, then throw an error.
    if [[ -z "$inputRef" ]]; then
        throw --error-message "--ref|-r <ref> is required."
        return ${FALSE}
    elif [[ -z "$inputKey" ]]; then
        throw --error-message "--key|-k <key> is required."
        return ${FALSE}
    fi
    
    # check the reference variable type
    local actualType=$(typeset -p ${inputRef} 2>/dev/null)
    if [[ "$actualType" != 'typeset -g -A '* ]]; then
        throw --error-message "The reference variable --ref|-r <ref> must be a hash list."
        return ${FALSE}
    fi

    # check the key exists.
    eval "
        if [[ ! -v ${inputRef}[\$inputKey] ]]; then
            throw --error-message "The key:${inputKey} does not exist."
            return ${FALSE}
        fi
    "

    # delete the key.
    eval "unset \"${inputRef}[$inputKey]\""
}

##
# @param --ref|-r <ref> The name of the variable to create.
# @param --key|-k <key> The key to check.
# @return <boolean>
##
function has() { 
    local inputRef=''
    local inputKey=''
    local args=("$@")
    local i;
    for (( i = 1; i <= ${#args}; i++ )); do
        local arg="${args[$i]}"
        if [[ "$arg" == '--ref' || "$arg" == '-r' ]]; then
            inputRef="${args[$i+1]}"
        elif [[ "$arg" == '--key' || "$arg" == '-k' ]]; then
            inputKey="${args[$i+1]}"
        fi
    done

    # if the input ref was empty, then throw an error.
    if [[ -z "$inputRef" ]]; then
        throw --error-message "--ref|-r <ref> is required."
        return ${FALSE}
    elif [[ -z "$inputKey" ]]; then
        throw --error-message "--key|-k <key> is required."
        return ${FALSE}
    fi

    # if the input ref was not a hash list, then throw an error.
    if [[ "$(typeset -p ${inputRef} 2>/dev/null)" != 'typeset -g -A '* ]]; then
        throw --error-message "The reference variable --ref|-r <ref> must be a hash list."
        return ${FALSE}
    fi

    # check the key exists.
    eval "
        if [[ ! -v ${inputRef}[\$inputKey] ]]; then
            return ${FALSE}
        else
            return ${TRUE}
        fi
    "
}

##
# @param --ref|-r <ref> The name of the variable to create.
# @echo <number>
##
function size() { 
    local inputRef=''
    local args=("$@")
    local i;
    for (( i = 1; i <= ${#args}; i++ )); do
        local arg="${args[$i]}"
        if [[ "$arg" == '--ref' || "$arg" == '-r' ]]; then
            inputRef="${args[$i+1]}"
            break
        fi
    done

    # if the input ref was empty, then throw an error.
    if [[ -z "$inputRef" ]]; then
        throw --error-message "--ref|-r <ref> is required."
        return ${FALSE}
    fi

    # if the input ref was not a hash list, then throw an error.
    if [[ "$(typeset -p ${inputRef} 2>/dev/null)" != 'typeset -g -A '* ]]; then
        throw --error-message "The reference variable --ref|-r <ref> must be a hash list."
        return ${FALSE}
    fi

    # get the size.
    eval "
        echo \${#${inputRef}[@]}
    "
}

##
# @param --ref|-r <ref> The name of the variable to create.
# @return <boolean>
##
function clear() { 
    local inputRef=''
    local args=("$@")
    local i;
    for (( i = 1; i <= ${#args}; i++ )); do
        local arg="${args[$i]}"
        if [[ "$arg" == '--ref' || "$arg" == '-r' ]]; then
            inputRef="${args[$i+1]}"
            break
        fi
    done

    # if the input ref was empty, then throw an error.
    if [[ -z "$inputRef" ]]; then
        throw --error-message "--ref|-r <ref> is required."
        return ${FALSE}
    fi

    # if the input ref was not a hash list, then throw an error.
    if [[ "$(typeset -p ${inputRef} 2>/dev/null)" != 'typeset -g -A '* ]]; then
        throw --error-message "The reference variable --ref|-r <ref> must be a hash list."
        return ${FALSE}
    fi

    # clear the hash list.
    eval "${inputRef}=()"
}