#!/usr/bin/env zsh

function test_example_module_loading() {
    local actualVal=$(${ZMOD_DIR}/bin/zmod ${ZMOD_DIR}/example/module-loading/lib/main.zsh 2>&1)
    expect_equal --actual "$?" --expected "0"
    local expectedVal="hello"
    expect_equal --actual "${actualVal}" --expected "${expectedVal}"
}