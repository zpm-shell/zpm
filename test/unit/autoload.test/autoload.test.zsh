#!/usr/bin/env zsh

. "${ZPM_DIR}/src/autoload.zsh"

import ./m1.zsh --as m1

function test_import() {
  local actualVal=$( ${ZPM_DIR}/test/unit/autoload.test/m1.zsh:3:m1 )
  expect_equal --actual "${actualVal}" --expected "m1"
}

function test_import_at_file_path() {
  import @/test/unit/autoload.test/m2.zsh --as m2
  expect_equal --actual "$?" --expected "0"
  local actualVal=$( ${ZPM_DIR}/test/unit/autoload.test/m2.zsh:3:m2 )
  expect_equal --actual "${actualVal}" --expected "m2 func"
}

function test_import_with_absolute_path() {
  import "${ZPM_DIR}/test/unit/autoload.test/m3.zsh" --as m3
  expect_equal --actual "$?" --expected "0"
  local actualVal=$( ${ZPM_DIR}/test/unit/autoload.test/m3.zsh:3:m3 )
  expect_equal --actual "${actualVal}" --expected "m3 func"
}

function test_import_circul() {
  import "./circul1.zsh" --as circul1
  local actualVal=$( ${ZPM_DIR}/test/unit/autoload.test/circul1.zsh:5:circul1)
  expect_equal --actual "${actualVal}" --expected "circul1"
  actualVal=$( ${ZPM_DIR}/test/unit/autoload.test/circul2.zsh:5:circul2)
  expect_equal --actual "${actualVal}" --expected "circul2"
}

function test_same_as_name() {
  local actual=$(
  import "./m4.zsh" --as circul1;
  import "./m5.zsh" --as circul1
  )
  local expectedValPath="${ZPM_DIR}/test/unit/autoload.test/test_same_as_name_function_test_result_compaire_txt.txt"
  # echo "${actual}" > ${expectedValPath} 
  expect_equal --actual "${actual}" --expected "$(cat ${expectedValPath})"
}

function test_import_self() {
  import ./m7.zsh --as m7
  local actual=$( call m7.callSelfFunc)
  expect_equal --actual "${actual}" --expected "hello"
}

function test_relative_module_path() {
  import ../../../test/unit/autoload.test/m8.zsh --as m8
  local actual=$(call m8.func)
  expect_equal --actual "${actual}" --expected "hello"
}

function test_relative_module_path2() {
  import ./../../../test/unit/autoload.test/m9.zsh --as m9
  local actual=$(call m9.func)
  expect_equal --actual "${actual}" --expected "hello"
}

# test the as name with the character '-'
function test_as_name_with_character_dash() {
  import ./m10.zsh --as name-with-dash
  local actual=$(call name-with-dash.func)
  expect_equal --actual "${actual}" --expected "hello"
}