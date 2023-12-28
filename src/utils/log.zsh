function debug() {
    local calltrace=($(zpm_calltrace -l 3))
    local colorSymbol="[\e[1;93mDEBUG\e[0m]"
    if [[ "${ZPM_LOG_LEVEL}" == "DEBUG" ]]; then
        echo "${calltrace[1]} ${colorSymbol} $1"
    fi
}

function info() {
    local calltrace=($(zpm_calltrace -l 3))
    local colorSymbol="[\e[1mINFO\e[0m]"
    echo "${calltrace[1]} ${colorSymbol} $1"
}
