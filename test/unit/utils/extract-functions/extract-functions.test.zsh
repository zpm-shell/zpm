function test_extract_functions() {
    local actualListVal=$(extract_functions --zsh-file "${ZMOD_DIR}/test/unit/utils/extract-functions/extract-functions-example.zsh")
    expect_equal "${actualListVal}" "1:fun1 5:fun2 9:fun3"
}
