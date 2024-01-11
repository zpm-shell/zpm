#!/usr/bin/env bash

##
# get the change log by tag name
# @usage: ./change_log.sh <tag name>
# @example: ./change_log.sh v0.0.59
#          - test(unit): update the unit test for generate_unique_var_name function
#          - fix: fix the issue  with incorrect information printed by assert_not_empty_test function
#          - feat(cli): add the bin tar for proxy cli
#          - feat(cli): add the installer for proxy cli '
#          - chore: update submodule
# @auther: wuchuheng<root@wuchuheng>
# @date: 2024-01-07 15:43
##

tagName="$1"

error_msg() {
  echo -e "\033[31m$1\033[0m"
  exit 1;
}

# check if the tag name must be not empty.
if [[ -z "${tagName}" ]]; then
  error_msg "The tag name must be not empty."
fi

result=''
TRUE=0
FALSE=1
isTextLog="${FALSE}"
while IFS= read -r line || [[ -n "$line" ]]; do
  if [[ "${line}" =~ "## [${tagName}]"* ]]; then
    isTextLog="${TRUE}"
    continue
  else
    if [[ ${line} != "## [Unreleased]" && "${line}" == "## "* ]]; then
      break
    fi
    if [[ "${isTextLog}" -eq "${TRUE}" ]]; then
      result="${result}${line}\n"
    fi
  fi
done < "CHANGELOG.md"

# remove the empty line.
while true; do
  if [[ ${result:${#result} - 2} == "\n" ]]; then
     result=${result:0:${#result} - 2}
  else
    break
  fi
done

echo -e "${result}"
