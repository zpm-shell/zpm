#!/usr/bin/env zsh

testDebug() {
  expect_equal "1" "1"
}

testHello() {
  expect_equal "3" "1"
  expect_equal "3" "1"
}

testFoo() {
  expect_equal "1" "1"
}

#print -rl -- ${(ok)functions}

