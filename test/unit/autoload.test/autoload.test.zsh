#!/usr/bin/env zsh

. "${ZMOD_DIR}/src/autoload.zsh"

import --from ./m1.zsh --as m1

function test_import() {
  local actualVal=$( ${ZMOD_DIR}/test/unit/autoload.test/m1.zsh:3:m1 )
  expect_equal --actual "${actualVal}" --expected "m1"
}

function test_import_at_file_path() {
  import --from @/test/unit/autoload.test/m2.zsh --as m2
  expect_equal --actual "$?" --expected "0"
  local actualVal=$( ${ZMOD_DIR}/test/unit/autoload.test/m2.zsh:3:m2 )
  expect_equal --actual "${actualVal}" --expected "m2 func"
}

function test_import_with_absolute_path() {
  import --from "${ZMOD_DIR}/test/unit/autoload.test/m3.zsh" --as m3
  expect_equal --actual "$?" --expected "0"
  local actualVal=$( ${ZMOD_DIR}/test/unit/autoload.test/m3.zsh:3:m3 )
  expect_equal --actual "${actualVal}" --expected "m3 func"
}