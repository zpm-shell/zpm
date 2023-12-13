#!/usr/bin/env zsh

function get_help_docs() {
  local expectVal=$(cat <<EOF
zpm <command> [ script.zsh ]

Usage:

zpm install                                install all the dependencies in your project
zpm install <foo>                          add the <foo> dependency to your project
zpm test                                   run this project's tests
zpm run <foo>                              run the script named <foo>
zpm init <repository/username/module-name> create a zpm.json5 file
zpm --help,-h                              print the help documentation
zpm -v,--version                           print the help documentation
zpm [script.zsh]                           execute the script

zpm@0.0.1 ${ZPM_DIR}/bin/zpm
EOF
)

  echo "${expectVal}"
}

function test_zpm_cli_helpe_docs() {
  local actualVal;
  actualVal=$( ${ZPM_DIR}/bin/zpm --help 2>&1)
  expect_equal --actual "$?" --expected "0"
  local expectVal=$(get_help_docs)
  expect_equal --actual "${actualVal}" --expected "${expectVal}"

  actualVal=$( ${ZPM_DIR}/bin/zpm -h 2>&1 )
  expect_equal --actual "$?" --expected "0"
  expect_equal --actual "${actualVal}" --expected "${expectVal}"
}

function test_zpm_cli_version() {
  local actualVal;
  actualVal=$( ${ZPM_DIR}/bin/zpm --version 2>&1)
  expect_equal --actual "$?" --expected "0"
  expect_equal --actual "${actualVal}" --expected "0.0.1"

  actualVal=$( ${ZPM_DIR}/bin/zpm -v 2>&1 )
  expect_equal --actual "$?" --expected "0"
  expect_equal --actual "${actualVal}" --expected "0.0.1"
}

function test_zpm_cli() {
  ${ZPM_DIR}/bin/zpm >> /dev/null 2>&1  
  expect_equal --actual "${?}" --expected "1"
  local actualVal=$( ${ZPM_DIR}/bin/zpm )
  
  expect_equal --actual "${actualVal}" --expected "$(get_help_docs)"
}

function test_zpm_cli_with_incorect_args() {
  ${ZPM_DIR}/bin/zpm --incorect-args >> /dev/null 2>&1  
  expect_equal --actual "${?}" --expected "1"
  local actualVal=$( ${ZPM_DIR}/bin/zpm --incorect-args)
  local expectVal=$(cat <<EOF
unknown arg: --incorect-args
try 'zpm --help'
EOF
)
  expect_equal --actual "${actualVal}" --expected "${expectVal}"
}