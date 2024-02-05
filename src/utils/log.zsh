#!/usr/bin/env zpm

import ./color.zsh --as color

function debug() {
    local calltrace=($(zpm_calltrace -l 3))
    local colorSymbol="[\e[1;93mDEBUG\e[0m]"
    if [[ "${ZPM_LOG_LEVEL}" == "DEBUG" ]]; then
        echo "${calltrace[1]} ${colorSymbol} $1"
    fi
}

##
# @param --no-path|-n: Do not print the file path
##
function info() {
    local isPrintPath=${FALSE}
    local args=("$@")
    local index=0;
    while [ $index -lt ${#args[@]} ]; do
        case ${args[$index]} in
            --no-path|-n)
                isPrintPath=${TRUE}
                ;;
        esac
        index=$((index+1))
    done
    
    local calltrace=($(zpm_calltrace -l 3))
    call color.reset
    call color.shape_bold
    local colorSymbol="[$(call color.print INFO)]"
    if [[ ${isPrintPath} -eq ${TRUE} ]]; then
        echo "${colorSymbol} $1"
    else
        echo "${calltrace[1]} ${colorSymbol} $1"
    fi
}

function success() {
    call color.reset
    call color.light_green
    call color.shape_bold
    echo -e "$(call color.print SUCCESS): $1"
}

function error() {
    local calltrace=($(zpm_calltrace -l 3))
    call color.reset
    call color.light_red
    call color.shape_bold
    local colorSymbol="$( call color.print ERROR )"
    echo "${calltrace[1]} ${colorSymbol} $1"
}