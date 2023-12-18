function test_extract_test_functions() {
    local actualVal=$(extract_test_functions "${ZPM_DIR}/test/unit/core/test/test_extract_test_functions.test.zsh")
    local exceptVal="test_extract_test_functions"
    expect_equal --expected "${exceptVal}" --actual "${actualVal}"
}
