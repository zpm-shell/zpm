#!/usr/bin/env zsh
function test_throw_with_level_stack() {
    local actualVal=$(cat <<EOF
$(throw --error-message "error message" --trace-level 1)
EOF
)
    local logFile="${ZMOD_DIR}/test/unit/utils/error/test_throw_with_level_stack.test.log"
    # echo "${actualVal}" > "${logFile}"
    local expectedVal=$(cat "${logFile}")
    expect_equal --actual "${actualVal}" --expected "${expectedVal}"
}
