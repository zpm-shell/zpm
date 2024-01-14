#!/usr/bin/env zsh

# set the global variable
# @param {string} $1 - global variable name
# @param {string} $2 - the value of the global variable
#
function set() {
  local globalVariableName=$1
  local value=$2

  eval "${globalVariableName}=${value}"
}

