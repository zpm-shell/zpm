# Extract list of functions to run tests against.
#
# Args:
#   script: string: name of script to extract functions from
# Returns:
#   string: of function names
extract_test_functions() {
  local script_=$1

  # Extract the lines with test function names, strip of anything besides the
  # function name, and output everything on a single line.
  local regex_='^\s*((function test[A-Za-z0-9_-]*)|(test[A-Za-z0-9_-]* *\(\)))'
  egrep "${regex_}" "${script_}" \
  |command sed 's/^[^A-Za-z0-9_-]*//;s/^function //;s/\([A-Za-z0-9_-]*\).*/\1/g' \
  |xargs
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
  ${backgroundRedColor} FAIL ${noColor} ${filePath}:${lineNumber}
  ${lightRed}● ${CURRENT_TEST_NAME}${noColor}
  Expected: ${lightGreen}${expected}${noColor}
  Received: ${lightRed}${actual}${noColor}
"
}


##
# @param --expected {string} the expected value
# @param --actual {string} the actual value
# @return <boolean>
##
function expect_equal() {
  local expected=''
  local actual=''
  local args=("$@")
  for (( i = 1; i <= ${#args[@]}; i++ )); do
    local arg=${args[$i]}
    case ${arg} in
      --expected)
        expected=$2
        shift 2;
        ;;
      --actual)
        actual=$2
        shift 2;
        ;;
    esac
  done

  local ok="${TRUE}"
  if [[ "${expected}" != "${actual}" ]]; then
    local prevFileLine="${funcfiletrace[1]}"
    local filePath="${prevFileLine%:*}"
    local lineNumber="${prevFileLine##*:}"
    _print_expected_error "${expected}" "${actual}" "${CURRENT_TEST_FILE}" "${lineNumber}"
    #  print the number line
    print_number_line --file-path "${filePath}" --line-number "${lineNumber}"
    ok="${FALSE}"
  fi


  # If the test results in a failure and was previously successful, mark it as a failure
  if [[ "${ok}" -eq "${FALSE}" && ${IS_CURRENT_TEST_OK} -eq "${TRUE}" ]]; then
    setGlobalVariables "IS_CURRENT_TEST_OK" "${FALSE}"
  fi

  return "${ok}"
}


