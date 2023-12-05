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

function test_import_circul() {
  import --from "./circul1.zsh" --as circul1
  local actualVal=$( ${ZMOD_DIR}/test/unit/autoload.test/circul1.zsh:5:circul1)
  expect_equal --actual "${actualVal}" --expected "circul1"
  actualVal=$( ${ZMOD_DIR}/test/unit/autoload.test/circul2.zsh:5:circul2)
  expect_equal --actual "${actualVal}" --expected "circul2"
}

function test_same_as_name() {
  local actual=$(
  import --from "./m4.zsh" --as circul1;
  import --from "./m5.zsh" --as circul1
  )
  local expectedValPath="${ZMOD_DIR}/test/unit/autoload.test/test_same_as_name_function_test_result_compaire_txt.txt"
  # echo "${actual}" > ${expectedValPath} 
  expect_equal --actual "${actual}" --expected "$(cat ${expectedValPath})"
}

function test_import_self() {
  import --from ./m7.zsh --as m7
  local actual=$( call m7.callSelfFunc)
  expect_equal --actual "${actual}" --expected "hello"
}