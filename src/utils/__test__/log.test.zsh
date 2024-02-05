#!/usr/bin/env zsh 

import ../../core/test_beta.zsh --as test
import ../log.zsh --as log

function test_info() {
    local e="[[1mINFO[0m] hello"
    local a=$(call log.info "hello" --no-path)
    call test.equal -a "${a}" -e "$e"
}