#!/usr/bin/env zsh

local unitTestFiles=(
  "${ZMOD_DIR}/test/unit/utils/test/expect_equal.test.zsh"

  "${ZMOD_DIR}/test/unit/utils/debug/assert_gt.test.zsh"
  "${ZMOD_DIR}/test/unit/utils/debug/assert_equal.test.zsh"
  "${ZMOD_DIR}/test/unit/utils/debug/assert_egt.test.zsh"
  "${ZMOD_DIR}/test/unit/utils/debug/debug-exit-code.test.zsh"
  
  "${ZMOD_DIR}/test/unit/utils/error/print_number_line.test.zsh"
  "${ZMOD_DIR}/test/unit/utils/error/print_number_line-exit-code.test.zsh"
)
