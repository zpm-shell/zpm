#!/usr/bin/env zsh

local integrateTestFiles=(
  "${ZMOD_DIR}/test/integration/zmod-cli.test.zsh"
  "${ZMOD_DIR}/test/integration/zmod-cli-execute-script.test.zsh"
)

local confFile=''
for confFile in ${integrateTestFiles[@]}; do
  echo "${confFile}"
done
