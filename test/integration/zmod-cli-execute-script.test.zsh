#!/usr/bin/env zsh

function test_example_module_loading() {
    local actualVal=$(
        cd ${ZMOD_DIR}/example/module-loading;
        ZMOD_WORKSPACE="${ZMOD_DIR}/example/module-loading" ${ZMOD_DIR}/bin/zmod lib/main.zsh 2>&1 
    )
    expect_equal --actual "$?" --expected "0"
    local expectedVal="hello"
    expect_equal --actual "${actualVal}" --expected "${expectedVal}"
}