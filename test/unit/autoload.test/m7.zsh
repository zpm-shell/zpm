#!/usr/bin/env zsh

import ./m7.zsh --as this

function func() {
    echo "hello"
}

function callSelfFunc() {
    call this.func
}