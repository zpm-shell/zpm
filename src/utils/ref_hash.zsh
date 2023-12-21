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

    eval " typeset -g -A ${inputRef}=() "
}

function keys() { }

function values() { }

function get() { }

function set() { }

function delete() { }

function has() { }

function size() { }

function clear() { }