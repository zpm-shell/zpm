#!/usr/bin/env zpm

##
# get the bin path of json query tools.
# @echo <string> a bin path.
##
function jq() {
    echo "${ZPM_DIR}/src/qjs-tools/bin/jq"
}