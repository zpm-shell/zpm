#!/usr/bin/env zsh

local currentDir="$(dirname ${0:A})"

source "${currentDir}/utils/error.zsh"
source "${currentDir}/utils/debug.zsh"

#echo "The absolute path of the current script is: $current_file"

# the mod app base path
typeset -g MOD_APP_BASE_PATH=$(pwd)


##
# @example: import fun1, fun2, fun3 from 'modules/m1'
# @param {string} $1: the module name
import() {

  assert_egt 3 "$#"


}

import m1, m2
