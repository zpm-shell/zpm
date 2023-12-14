#!/usr/bin/env zsh

local integrateTestFiles=(
  "${ZPM_DIR}/test/integration/zpm-cli.test.zsh"
  "${ZPM_DIR}/test/integration/zpm-cli-execute-script.test.zsh"
  "${ZPM_DIR}/test/integration/qjs-tools-bin.test.zsh"
  "${ZPM_DIR}/test/integration/qjs-tools-zpm-bin.zsh"
  "${ZPM_DIR}/qjs-tools-zpm-cli-args-parser.zsh"
)

local confFile=''
for confFile in ${integrateTestFiles[@]}; do
  echo "${confFile}"
done
