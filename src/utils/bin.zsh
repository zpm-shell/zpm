#!/usr/bin/env zpm

##
# get the bin path of json query tools.
# @echo <string> a bin path.
##
function jq() {
    echo "${ZPM_DIR}/src/qjs-tools/bin/jq"
}

##
# replace the variable to file with the varialbe name,like to replace a tmp.json file:
# {
#    "name": "${{NAME}}",
#    "version": "${{VERSION}}"
# }
# bin/replace-variable VERSION=0.0.1 NAME=hello DESCRIPTION=hello -f tmp.json
# and then 
# {
#    "name": "hello",
#    "version": "0.0.1"
# }
function rv() {
    local rv="${ZPM_DIR}/src/qjs-tools/bin/replace-variable"
    $rv $@
}