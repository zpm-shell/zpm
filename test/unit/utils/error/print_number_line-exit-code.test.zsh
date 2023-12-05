#!/usr/bin/env zsh

function test_print_number_line-exit-code() {
    # the function print_number_line executes successfully was expected.
    local currentFile="${ZMOD_DIR}/test/unit/utils/error/print_number_line-exit-code.test.zsh";
    print_number_line --file-path "${currentFile}" --line-number 6 > /dev/null 2>&1
    expect_equal --expected $? --actual 0
    
    # it should fail when the current line number is not a number.
    local currentFile="${ZMOD_DIR}/test/unit/utils/error/print_number_line-exit-code.test.zsh";
    print_number_line --file-path "${currentFile}" --line-number "abc" > /dev/null 2>&1
    expect_equal --expected $? --actual 1

    # it should fail when the current line number is greater than the number of lines in the file.
    local currentFile="${ZMOD_DIR}/test/unit/utils/error/print_number_line-exit-code.test.zsh";
    print_number_line --file-path "${currentFile}" --line-number "11111" > /dev/null 2>&1
    expect_equal --expected $? --actual 1

    # it should fail when the file does not exist.
    local notExistFile="${ZMOD_DIR}/test/unit/utils/error/not-exist.file";
    print_number_line --file-path "${notExistFile}" --line-number "1" > /dev/null 2>&1
    expect_equal --expected $? --actual 1
}
