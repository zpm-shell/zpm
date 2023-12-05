#!/usr/bin/env zsh

. "${ZMOD_DIR}/src/autoload.zsh"

import --from ./m1.zsh --as m1
import --from @/test/unit/autoload.test/m2.zsh --as m2

function test_import() {
  local actualVal=$( ${ZMOD_DIR}/test/unit/autoload.test/m1.zsh:3:m1 )
  expect_equal --actual "${actualVal}" --expected "m1"
}
