#!/usr/bin/env zsh

##
# @brief print the number line of a file between 1-10
# @param --file-path: file path
# @param --line-number:  line number
# @use print_number_line --file-path /Users/username/tmp.sh --line-number 5
# @example print_number_line --file-path /Users/username/tmp.sh --line-number 5

# @return
#
#    1  | readonly ALL_UNIT_TEST_FILES=(
#    2  | utils/__test__/unit_tests/1_helper.test.sh
#    3  | utils/__test__/unit_tests/2_helper.test.sh
#    4  | utils/__test__/unit_tests/3_helper.test.sh
#  > 5  | utils/__test__/unit_tests/4_helper.test.sh
#    6  | utils/__test__/unit_tests/5_helper.test.sh
#    7  | utils/__test__/unit_tests/6_helper.test.sh
#    8  | utils/__test__/unit_tests/7_helper.test.sh
#    9  | utils/__test__/unit_tests/8_helper.test.sh
#    10 | utils/__test__/unit_tests/9_helper.test.sh
#    11 | utils/__test__/unit_tests/10_helper.test.sh
#
##
function print_number_line() {
  local filePath=''
  local lineNumber=''
  # parse the arguments
  local args=("$@")
  for (( i = 1; i <= ${#args[@]}; i++ )); do
    local arg=${args[$i]}
    case $arg in
      --file-path)
        filePath="$2"
        shift # past argument=value
        ;;
      --line-number)
        lineNumber="$2"
        shift # past argument=value
        ;;
      *)
        shift
        ;;
    esac
  done
  if [[ -z "${filePath}" || -z "${lineNumber}" ]]; then
    echo "Error: missing argument."
    return "${FALSE}"
  fi


  # assert the file exists
  if [[ ! -f "${filePath}" ]]; then
    echo "File ${filePath} does not exist."
    return "${FALSE}"
  fi
  # assert the line number is valid
  if [[ ! ${lineNumber} =~ ^[0-9]+$ ]]; then
    echo "The line number must be a number."
    return "${FALSE}"
  fi
  # assert the line number was not greater than the file line
  if (( ${lineNumber} > $(wc -l ${filePath} | awk '{print $1}') + 1  )); then
    echo "The line number must be less than the file line."
    return "${FALSE}"
  fi
  local allLine=$(wc -l ${filePath} | awk '{print $1}')
  local intervalStart=$lineNumber # 区间开始坐标
  local intervalEnd=$lineNumber # 区间结始坐标
  for (( i=1; i <= 5; i++ )); do
    if ((((intervalStart - 1)) > 0)) ; then
      ((intervalStart--))
    else
      ((intervalEnd++))
    fi
    if (( ((intervalEnd + 1)) <= ${allLine} )); then
      ((intervalEnd++))
    else
      if ((((intervalStart - 1)) > 0)) ; then
        ((intervalStart--))
      fi
    fi
  done
  local result=`sed -n "${intervalStart},${intervalEnd}p" $filePath`
  local cln=${intervalStart}
  local lineNumberWidth=${#intervalEnd}
  while IFS= read -r line; do
    local gray="\e[90m"
    local noColor="\e[0m"
    if (( cln == lineNumber )); then
      printf " \e[91;1m>${noColor} ${gray}%-${lineNumberWidth}s |${noColor} $line\n" $cln
    else
      printf "   ${gray}%-${lineNumberWidth}s |${noColor} $line\n" $cln
    fi
    ((cln++))
  done <<< "$result"
}

##
# @param --error-message: {string} default: '', the error message 
# @param --trace-level: {number} default: 1, the level of the function call stack
# @param --exit-code: {number} default null, the exit code
# @use throw --error-message "error message" --trace-level 2 --exit-code 1
# @example throw --error-message "error message" --trace-level 2 --exit-code 1
##
function throw() {
  local errorMessage=''
  local funcFileTraceLevel=1
  local exitCode=''
  # parse the arguments
local args=("$@")
for (( i = 1; i <= ${#args[@]}; i++ )); do
  local arg=${args[$i]}
    case $arg in
      --error-message)
        errorMessage="$2"
        shift # past argument=value
        ;;
      --trace-level)
        funcFileTraceLevel="$2"
        shift # past argument=value
        ;;
      --exit-code)
        exitCode="$2"
        shift
        ;;
        *)
        shift;
        ;;
    esac
  done
  if [[ -z "${errorMessage}" ]]; then
    throw --error-message "the erroe message not provided." --trace-level 2 --exit-code "${exitCode}"
    return "${exitCode}"
  fi

  local prevFileLine="${funcfiletrace[${funcFileTraceLevel}]}"

  # print the error detail.
  local redColor="\e[0;31m"
  local noColor="\e[0m"
  printf "${redColor}Error: ${errorMessage}${noColor}\n"

  #2 print the number line in the file
  #2.1 Splitting the file path and line number
  local filePath="${prevFileLine%:*}"
  local lineNumber="${prevFileLine##*:}"
  #2.2 print the number line in the file
  if [[ -z ${filePath} ]]; then
      local funcAliasName=${CALL_STACE[-1]}
      local filePath=${funcAliasName%%:*}
      local newLineNumber=${funcAliasName#*:}
      newLineNumber=${newLineNumber%:*}
      lineNumber=$(( ${lineNumber} + ${newLineNumber}  ))
  fi
  print_number_line --file-path "${filePath}" --line-number "${lineNumber}"

  #3 print the function call stack
  local callStraceIndex=${#CALL_STACE[@]}
  for (( i = ${funcFileTraceLevel}; i <= ${#funcfiletrace[@]}; i++ )); do
    local stackNumberLine=${funcfiletrace[$i]}
    # if the file path was empty, then get the file path from call trace
    if [[ ${stackNumberLine:0:1} == ":" ]]; then
      local funcAliasName=${CALL_STACE[$callStraceIndex]}
      stackNumberLine=${funcAliasName%:*}
      callStraceIndex=$(( ${callStraceIndex} - 1 ))
    fi
    if [[ ${#stackNumberLine} -gt ${#ZMOD_WORKSPACE} && ${stackNumberLine:0:${#ZMOD_WORKSPACE}} == ${ZMOD_WORKSPACE} ]]; then
        stackNumberLine=${stackNumberLine#${ZMOD_WORKSPACE}/}
    fi
    printf " ${stackNumberLine}\n"
  done

  #4 if the exit code was not null and not 0, return the exit code
  if [[ ! -z "${exitCode}" && "${exitCode}" != 0 ]]; then
    exit "${exitCode}";
  else
    return "${FALSE}"
  fi
}
