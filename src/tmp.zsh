#!/usr/bin/env zsh


# get the tmp funtion standard output but not the error

tmpList=()

tmpList+=("1")
tmpList+=("2")
tmpList+=("3")


# print the last element of the array
echo ${tmpList[-1]}

