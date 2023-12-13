#!/usr/bin/env zsh

local unitTestFiles=(
  "${ZPM_DIR}/test/unit/utils/test/expect_equal.test.zsh"
  "${ZPM_DIR}/test/unit/utils/test/test_extract_test_functions.test.zsh"

  "${ZPM_DIR}/test/unit/utils/debug/assert_gt.test.zsh"
  "${ZPM_DIR}/test/unit/utils/debug/assert_equal.test.zsh"
  "${ZPM_DIR}/test/unit/utils/debug/assert_egt.test.zsh"
  "${ZPM_DIR}/test/unit/utils/debug/debug-exit-code.test.zsh"
  
  "${ZPM_DIR}/test/unit/utils/error/print_number_line.test.zsh"
  "${ZPM_DIR}/test/unit/utils/error/print_number_line-exit-code.test.zsh"

  "${ZPM_DIR}/test/unit/utils/error/throw.test.zsh"
  "${ZPM_DIR}/test/unit/utils/error/throw_with_level_stack.test.zsh"
  "${ZPM_DIR}/test/unit/utils/extract-functions/extract-functions.test.zsh"

  "${ZPM_DIR}/test/unit/autoload.test/autoload.test.zsh"
  "${ZPM_DIR}/test/unit/call.test/call.test.zsh"
)

local confFile=''
for confFile in ${unitTestFiles[@]}; do
  echo "${confFile}"
done
