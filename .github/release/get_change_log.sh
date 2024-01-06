#!/usr/bin/env bash

##
# get the change log by tag name
# @use ./get_change_log.sh <tag name>
# @example ./get_change_log.sh v0.0.59
#          - test(unit): update the unit test for generate_unique_var_name function
#          - fix: fix the issue  with incorrect information printed by assert_not_empty_test function
#          - feat(cli): add the bin tar for proxy cli
#          - feat(cli): add the installer for proxy cli '
#          - chore: update submodule
##

tagName="$1"
result=''
TRUE=0
FALSE=1
isTextLog="${FALSE}"
while IFS= read -r line || [[ -n "$line" ]]; do
  if [[ "${isTextLog}" -eq "${TRUE}" ]]; then
    result="${result}${line}\n"
  fi
  if [[ "${line}" =~ "## [${tagName}]"* ]]; then
    isTextLog="${TRUE}"
    continue
  else
    if [[ ${line} != "## [Unreleased]" && "${line}" == "## "* ]]; then
      break
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
