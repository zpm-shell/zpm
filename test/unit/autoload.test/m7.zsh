#!/usr/bin/env zsh

import --from ./m7.zsh --as this

function func() {
    echo "hello"
}

function callSelfFunc() {
    call this.func
}