#!/usr/bin/env zsh

. "${ZMOD_DIR}/src/autoload.zsh"

import --from ./m1.zsh --as m1

function test_import() {
  local actualVal=$( ${ZMOD_DIR}/test/unit/autoload.test/m1.zsh:3:m1 )
  expect_equal --expected "${actualVal}" --actual "m1"
}
