#!/usr/bin/env zsh

import ./m2.zsh --as m2

function m1() {
    call m2.m2
}