#!/usr/bin/env zsh

function test_assert_gt() {
  local actualVal=$(cat <<EOF
$(assert_gt "1" "2")
EOF
)
  # echo "${actualVal}" > test/unit/core/debug/assert-gt-val.log
  local expectVal=$(cat test/unit/core/debug/assert-gt-val.log)
  expect_equal --expected "${expectVal}" --actual "${actualVal}"
}