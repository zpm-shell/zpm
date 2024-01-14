#!/usr/bin/env zsh
import ../utils/color.zsh --as color
import ./test_beta.zsh --as self
import ../utils/global.zsh --as global

# Extract list of functions to run tests against.
#
# Args:
#   script: string: name of script to extract functions from
# Returns:
#   string: of function names
function extract_test_functions() {
  local script_=$1

  # Extract the lines with test function names, strip of anything besides the
  # function name, and output everything on a single line.
  local regex_='^\s*((function test[A-Za-z0-9_-]*)|(test[A-Za-z0-9_-]* *\(\)))'
  egrep "${regex_}" "${script_}" \
  |command sed 's/^[^A-Za-z0-9_-]*//;s/^function //;s/\([A-Za-z0-9_-]*\).*/\1/g' \
  |xargs
}

##
# print the result of the current test
##
function print_current_test_result() {
  local testFunc=$1
  local isCurrentTestOk=$2
  
  if [[ ${isCurrentTestOk} -eq ${TRUE} ]]; then
    call color.reset
    call color.light_green
    call color.shape_bold
    echo "  $(call color.print OK) ${testFunc}"
  fi
}

local backgroundRedColor="\e[1;97;101m"
local noColor="\e[0m"
local lightRed="\e[0;91m"
local lightGreen="\e[0;92m"
local lightRed="\e[0;91m"

##
# print the expected error
# @param string $1: expected value
# @param string $2: actual value
# @param string $3: the file path"${filePath}" ${lineNumber}
# @param string $4: the file path"${filePath}" ${lineNumber}
##
function _print_expected_error() {
  local expected=$1
  local actual=$2
  local filePath=$3
  local lineNumber=$4

  echo "
  $(call color.background_red; call color.shape_bold; call color.print ' FAIL ') ${filePath}:${lineNumber}
  Expected: ${lightGreen}${expected}${noColor}
  Received: ${lightRed}${actual}${noColor}
"
}


##
# @param --expected|-e {string} the expected value
# @param --actual|-a {string} the actual value
# @return <boolean>
##
function equal() {
  local expected=''
  local actual=''
  local args=("$@")
  for (( i = 1; i <= ${#args[@]}; i++ )); do
    local arg=${args[$i]}
    case ${arg} in
      --expected|-e)
        expected=$2
        shift 2;
        ;;
      --actual|-a)
        actual=$2
        shift 2;
        ;;
    esac
  done

  local ok="${TRUE}"
  if [[ "${expected}" != "${actual}" ]]; then
    local prevFileLine="${funcfiletrace[2]}"
    local filePath="${prevFileLine%:*}"
    local lineNumber="${prevFileLine##*:}"
    call self._print_expected_error "${expected}" "${actual}" "${CURRENT_TEST_FILE}" "${lineNumber}"
    #  print the number line
    print_number_line --file-path "${filePath}" --line-number "${lineNumber}"
    ok="${FALSE}"
  fi


  # If the test results in a failure and was previously successful, mark it as a failure
  if [[ "${ok}" -eq "${FALSE}" && ${IS_CURRENT_TEST_OK} -eq "${TRUE}" ]]; then
    call global.set "IS_CURRENT_TEST_OK" "${FALSE}"
  fi

  return "${ok}"
}