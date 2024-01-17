#!/usr/bin/env zpm

import ../../../core/test_beta.zsh --as test

function test_create_dotfiles() {
    call test.equal -e 1 -a 1
}