function debug() {
    local calltrace=($(zpm_calltrace -l 3))
    local colorSymbol="[\e[1;93mDEBUG\e[0m]"
    echo "${calltrace[1]} ${colorSymbol} $1"
}

function info() {
    local calltrace=($(zpm_calltrace -l 3))
    local colorSymbol="[\e[1mINFO\e[0m]"
    echo "${calltrace[1]} ${colorSymbol} $1"
}
