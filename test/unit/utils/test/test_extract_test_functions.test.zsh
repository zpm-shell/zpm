function test_extract_test_functions() {
    local actualVal=$(extract_test_functions "${ZMOD_DIR}/test/unit/utils/test/test_extract_test_functions.test.zsh")
    local exceptVal="test_extract_test_functions"
    expect_equal "${exceptVal}" "${actualVal}"
}
