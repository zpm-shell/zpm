#!/usr/bin/zsh

import --from ./m2.zsh --as m2

m1() {
    call m2.m2
}