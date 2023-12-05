#!/usr/bin/env zsh

function test_expect_equal() {
  local actualVal=$(cat <<EOF
$(expect_equal --expected "1" --actual "2")
EOF
)
  local expectVal=$(cat test/unit/utils/test/expect-equal-val.log)
  expect_equal --expected "${expectVal}" --actual "${actualVal}"

}