function test_extract_functions() {
    local actualListVal=$(extract_functions --zsh-file "${ZPM_DIR}/test/unit/utils/extract-functions/extract-functions-example.zsh")
    expect_equal --actual "${actualListVal}" --expected "1:fun1 5:fun2 9:fun3"
}
