#!/usr/bin/env zsh

function get_help_docs() {
  local expectVal=$(cat <<EOF
zmod <command> [ script.zsh ]

Usage:

zmod install        install all the dependencies in your project
zmod install <foo>  add the <foo> dependency to your project
zmod test           run this project's tests
zmod run <foo>      run the script named <foo>
zmod init           create a zmod.json5 file
zmod --help,-h      print the help documentation
zmod -v,--version   print the help documentation
zmod [script.zsh]   execute the script

zmod@0.0.1 ${ZMOD_DIR}/bin/zmod
EOF
)

  echo "${expectVal}"
}

function test_zmod_cli_helpe_docs() {
  local actualVal=$( ${ZMOD_DIR}/bin/zmod --help 2>&1)
  expect_equal --actual "$?" --expected "0"
  local expectVal=$(get_help_docs)
  expect_equal --actual "${actualVal}" --expected "${expectVal}"

  actualVal=$( ${ZMOD_DIR}/bin/zmod -h 2>&1 )
  expect_equal --actual "$?" --expected "0"
  expect_equal --actual "${actualVal}" --expected "${expectVal}"
}

function test_zmod_cli_version() {
  local actualVal=$( ${ZMOD_DIR}/bin/zmod --version 2>&1)
  expect_equal --actual "$?" --expected "0"
  expect_equal --actual "${actualVal}" --expected "0.0.1"

  local actualVal=$( ${ZMOD_DIR}/bin/zmod -v 2>&1 )
  expect_equal --actual "$?" --expected "0"
  expect_equal --actual "${actualVal}" --expected "0.0.1"
}

function test_zmod_cli() {
  ${ZMOD_DIR}/bin/zmod >> /dev/null 2>&1  
  expect_equal --actual "${?}" --expected "1"
  local actualVal=$( ${ZMOD_DIR}/bin/zmod )
  expect_equal --actual "${actualVal}" --expected "$(get_help_docs)"
}

function test_zmod_cli_with_incorect_args() {
  ${ZMOD_DIR}/bin/zmod --incorect-args >> /dev/null 2>&1  
  expect_equal --actual "${?}" --expected "1"
  local actualVal=$( ${ZMOD_DIR}/bin/zmod --incorect-args)
  local expectVal=$(cat <<EOF
unknown arg: --incorect-args
try 'zmod --help'
EOF
)
  expect_equal --actual "${actualVal}" --expected "${expectVal}"
}