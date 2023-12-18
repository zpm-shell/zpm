#!/usr/bin/env zsh
function test_throw() {
    local actualVal=$(cat <<EOF
$(throw --error-message "error message")
EOF
)
    local logFile="${ZPM_DIR}/test/unit/core/error/throw.test.log"
    # echo "${actualVal}" > "${logFile}"
    local expectedVal=$(cat "${logFile}")
    expect_equal --actual "${actualVal}" --expected "${expectedVal}"
}
