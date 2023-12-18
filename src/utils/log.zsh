function debug() {
    local prevFileLine="${funcfiletrace[2]}"
    local filePath="${prevFileLine%:*}"
    local lineNumber="${prevFileLine##*:}"
    local colorSymbol="[\e[1;93mDEBUG\e[0m]"
    echo "${filePath}:${lineNumber} ${colorSymbol} $1"
}

function info() {
    local prevFileLine="${funcfiletrace[2]}"
    local filePath="${prevFileLine%:*}"
    local lineNumber="${prevFileLine##*:}"
    local colorSymbol="[\e[1mINFO\e[0m]"
    echo "${filePath}:${lineNumber} ${colorSymbol} $1"
}
