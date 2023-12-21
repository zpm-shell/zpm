##
# create a list reference varible.
# @param --ref|-r: the reference variable name.
# @return <boolean>
function create() {
    local inputRef=''
    if [[ "$1" == '--ref' || "$1" == '-r' ]]; then
        inputRef="$2"
    fi
    if [[ -z "$inputRef" ]]; then
        throw --error-message "The param --ref required" --exit-code 1
    fi
    
    eval "
        typeset -g ${inputRef}=()
    "
}

##
# --param --ref|-r: the reference variable name.
# --param --value|-v: the value to add.
# @return <boolean>
##
function set() {
    local inputRef=''
    local inputValue=''
    local isInputValue=${FALSE}
    local args=("$@")
    local i;
    for (( i = 1; i <= ${#args}; i++ )); do
        local arg="${args[$i]}"
        if [[ "$arg" == '--ref' || "$arg" == '-r' ]]; then
            inputRef="${args[$i+1]}"
        elif [[ "$arg" == '--value' || "$arg" == '-v' ]]; then
            inputValue="${args[$i+1]}"
            isInputValue=${TRUE}
        fi
    done
    # check the input value
    if [[ -z ${inputRef} ]]; then
        throw --error-message "The param --ref|-r required"
    elif [[ ${isInputValue} -eq ${FALSE} ]]; then
        throw --error-message "The param --value|-v required"
    fi

    # check the reference variable type
    local actualType=$(typeset -p ${inputRef} 2>/dev/null)
    if [[ "$actualType" != 'typeset -g -a '* ]]; then
        throw --error-message "The variable ${inputRef} is not a list reference variable"
        return ${FALSE}
    fi

    # assign the value to the reference variable
    eval "
        ${inputRef}+=(\"${inputValue}\")
    "
}