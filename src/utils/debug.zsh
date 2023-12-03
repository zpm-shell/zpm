#!/usr/bin/env zsh

#@param $1: the expected value
#@param $2: the actual value
assert_equal() {
  if (( $1 != $2)); then
    throw --error-message "expected $1, but got $2" --trace-level 2
    return "${FALSE}"
  fi
}

#@param $1: the expected value
#@param $2: the actual value
assert_gt() {
  if (( $1 < $2 )); then
    throw --error-message "expected $1 to be greater than $2" --trace-level 2
    return "${FALSE}"
  fi
}

#@param $1: the expected value
#@param $2: the actual value
assert_egt() {
  if (( $1 < $2 )); then
    throw --error-message "expected $1 to be greater than or equal to $2" --trace-level 2
    return "${FALSE}"
  fi
}
