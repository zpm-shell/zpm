#!/usr/bin/env zsh


function self_func() {
    echo "hello"
}

function test_call() {
    import ./m1.zsh --as m1
    local actual=$(call m1.m1)
    expect_equal --expected "m2" --actual "${actual}"

}

function test_call_self() {
    import ./call.test.zsh --as self
    local actual=$( call self.self_func)
    expect_equal --expected "hello" --actual "${actual}"
}