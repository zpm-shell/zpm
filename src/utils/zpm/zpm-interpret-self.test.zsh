#!/usr/bin/env zpm

import ../../core/test_beta.zsh --as test

function test_interpret_self() {
    local a=$( ./src/utils/zpm/zpm-interpreter.test.zsh )
    call test.equal -a "${a}" -e hello
}
