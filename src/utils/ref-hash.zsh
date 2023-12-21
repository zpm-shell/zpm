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

function keys() { }

function values() { }

function get() { }

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

function delete() { }

function has() { }

function size() { }

function clear() { }