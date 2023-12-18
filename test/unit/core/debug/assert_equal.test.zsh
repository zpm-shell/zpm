#!/usr/bin/env zsh

function test_assert_equal() {
  local actualVal=$(cat <<EOF
$(assert_equal "1" "2")
EOF
)
  # echo "${actualVal}" > test/unit/core/debug/assert_equal-val.log
  local expectVal=$(cat test/unit/core/debug/assert_equal-val.log)
  expect_equal --expected "${expectVal}" --actual "${actualVal}"
}