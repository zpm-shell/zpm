#!/usr/bin/env zsh

local unitTestFiles=(
  "${ZPM_DIR}/test/unit/core/test/expect_equal.test.zsh"
  "${ZPM_DIR}/test/unit/core/test/test_extract_test_functions.test.zsh"

  "${ZPM_DIR}/test/unit/core/debug/assert_gt.test.zsh"
  "${ZPM_DIR}/test/unit/core/debug/assert_equal.test.zsh"
  "${ZPM_DIR}/test/unit/core/debug/assert_egt.test.zsh"
  "${ZPM_DIR}/test/unit/core/debug/debug-exit-code.test.zsh"
  
  "${ZPM_DIR}/test/unit/core/error/print_number_line.test.zsh"
  "${ZPM_DIR}/test/unit/core/error/print_number_line-exit-code.test.zsh"

  "${ZPM_DIR}/test/unit/core/error/throw.test.zsh"
  "${ZPM_DIR}/test/unit/core/error/throw_with_level_stack.test.zsh"
  "${ZPM_DIR}/test/unit/core/extract-functions/extract-functions.test.zsh"

  "${ZPM_DIR}/test/unit/autoload.test/autoload.test.zsh"
  "${ZPM_DIR}/test/unit/call.test/call.test.zsh"

  "${ZPM_DIR}/test/unit/utils/log.test.zsh"
  
  "${ZPM_DIR}/test/unit/utils/ref-list.test.zsh"
  "${ZPM_DIR}/test/unit/utils/ref.test.zsh"

  "${ZPM_DIR}/test/unit/utils/ref-hash.test.zsh"
)

local confFile=''
for confFile in ${unitTestFiles[@]}; do
  echo "${confFile}"
done
