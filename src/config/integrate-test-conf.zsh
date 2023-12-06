#!/usr/bin/env zsh

local integrateTestFiles=(
  "${ZMOD_DIR}/test/integration/zmod-cli.test.zsh"
)

local confFile=''
for confFile in ${integrateTestFiles[@]}; do
  echo "${confFile}"
done
