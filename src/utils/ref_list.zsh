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