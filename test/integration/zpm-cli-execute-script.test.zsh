#!/usr/bin/env zsh

function test_example_module_loading() {
    local actualVal;
    actualVal=$(
        cd ${ZPM_DIR}/example/module-loading;
        ZPM_WORKSPACE="${ZPM_DIR}/example/module-loading" ${ZPM_DIR}/bin/zpm run lib/main.zsh
    )
    expect_equal --actual "$?" --expected "0"
    local expectedVal="hello"
    expect_equal --actual "${actualVal}" --expected "${expectedVal}"
}