#!/usr/bin/env zsh

function test_expect_equal() {
  local actualVal=$(cat <<EOF
$(expect_equal "1" "2")
EOF
)
  local expectVal=$(cat test/expect-equal-val.log)
  expect_equal "${expectVal}" "${actualVal}"

}