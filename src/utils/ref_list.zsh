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

##
# get the size of the list reference variable.
# @--param --ref|-r: the reference variable name.
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
        fi
    done
    # check the input value
    if [[ -z ${inputRef} ]]; then
        throw --error-message "The param --ref|-r required"
    fi

    # check the reference variable type
    local actualType=$(typeset -p ${inputRef} 2>/dev/null)
    if [[ "$actualType" != 'typeset -g -a '* ]]; then
        throw --error-message "The variable ${inputRef} is not a list reference variable"
        return ${FALSE}
    fi

    # assign the value to the reference variable
    eval "
        echo \${#${inputRef}[@]}
    "
}

##
#  get the value of the list reference variable.
# @--param --ref|-r: the reference variable name.
# @echo <el1, el2, ...>
##
function values() {
    local inputRef=''
    local args=("$@")
    local i;
    for (( i = 1; i <= ${#args}; i++ )); do
        local arg="${args[$i]}"
        if [[ "$arg" == '--ref' || "$arg" == '-r' ]]; then
            inputRef="${args[$i+1]}"
        fi
    done
    # check the input value
    if [[ -z ${inputRef} ]]; then
        throw --error-message "The param --ref|-r required"
    fi

    # check the reference variable type
    local actualType=$(typeset -p ${inputRef} 2>/dev/null)
    if [[ "$actualType" != 'typeset -g -a '* ]]; then
        throw --error-message "The variable ${inputRef} is not a list reference variable"
        return ${FALSE}
    fi

    # assign the value to the reference variable
    eval "
        echo \${${inputRef}[@]}
    "
}

##
# get get the value of the list reference variable by index.
# @--param --ref|-r: the reference variable name.
# @--param --index|-i: the index of the value.
# @echo <string>
function get() {
    local inputRef=''
    local inputIndex=''
    local args=("$@")
    local i;
    for (( i = 1; i <= ${#args}; i++ )); do
        local arg="${args[$i]}"
        if [[ "$arg" == '--ref' || "$arg" == '-r' ]]; then
            inputRef="${args[$i+1]}"
        elif [[ "$arg" == '--index' || "$arg" == '-i' ]]; then
            inputIndex="${args[$i+1]}"
        fi
    done
    # check the input value
    if [[ -z ${inputRef} ]]; then
        throw --error-message "The param --ref|-r required"
    elif [[ -z ${inputIndex} ]]; then
        throw --error-message "The param --index|-i required"
    fi
    # check the input index must be a number and greater than 0
    if [[ ! ${inputIndex} =~ ^[0-9]+$ ]]; then
        throw --error-message "The param --index|-i must be a number"
        return ${FALSE}
    elif [[ ${inputIndex} -lt 1 ]]; then
        throw --error-message "The param --index|-i must be greater than 0"
        return ${FALSE}
    fi

    # check the reference variable type
    local actualType=$(typeset -p ${inputRef} 2>/dev/null)
    if [[ "$actualType" != 'typeset -g -a '* ]]; then
        throw --error-message "The variable ${inputRef} is not a list reference variable"
        return ${FALSE}
    fi

    # check the index exists in the list
    local len=$(eval "echo \${#${inputRef}[@]}")
    if [[ ${len} -lt ${inputIndex} ]]; then
        throw --error-message "The index ${inputIndex} is out of range"
        return ${FALSE}
    fi

    # echo the value
    eval "
        echo \${${inputRef}[$inputIndex]}
    "
}