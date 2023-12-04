function test_extract_functions() {
    local actualListVal=$(extract_functions --zsh-file "${ZMOD_DIR}/test/unit/utils/extract-functions/extract-functions-example.zsh")
    expect_equal "${actualListVal}" "fun1 fun2 fun3"
}
