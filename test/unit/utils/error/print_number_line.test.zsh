#!/usr/bin/env zsh
function test_print_number_line() {
    local currentFile="${ZMOD_DIR}/test/unit/utils/error/print_number_line.test.zsh"
    local actualVal=$(cat <<EOF
$(print_number_line --file-path "${currentFile}" --line-number 5)
EOF
)
    local logFile=test/unit/utils/error/print_number_line-val.log
    # echo "${actualVal}" > "${logFile}"
    local expectVal=$(cat "${logFile}")
    expect_equal "${expectVal}" "${actualVal}"
}
