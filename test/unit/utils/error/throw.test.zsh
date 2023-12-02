#!/usr/bin/env zsh
function test_throw() {
    local actualVal=$(cat <<EOF
$(throw "error message")
EOF
)
    local logFile="${ZMOD_DIR}/test/unit/utils/error/throw.test.log"
    # echo "${actualVal}" > "${logFile}"
    local expectedVal=$(cat "${logFile}")
    expect_equal "${actualVal}" "${expectedVal}"
}
