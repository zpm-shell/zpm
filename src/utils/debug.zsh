#!/usr/bin/env zsh

#@param $1: the expected value
#@param $2: the actual value
assert_equal() {
  if [[ "$1" != "$2" ]]; then
    throw "expected $1, but got $2" 2
  fi
}

#@param $1: the expected value
#@param $2: the actual value
assert_gt() {
  if [[ "$1" -gt "$2" ]]; then
    throw "expected $1 to be greater than $2" 2
  fi
}

#@param $1: the expected value
#@param $2: the actual value
assert_egt() {
  if [[ "$1" -ge "$2" ]]; then
    throw "expected $1 to be greater than or equal to $2" 2
  fi
}
